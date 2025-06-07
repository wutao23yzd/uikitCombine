# 深入理解 Swift Codable：从基础到进阶

## 目录
1. [Codable 简介](#codable-简介)  
2. [与 HandyJSON 的差异](#与-handyjson-的差异)  
3. [最小可用示例](#最小可用示例)  
4. [字段映射：CodingKeys](#字段映射codingkeys)  
5. [可选值、缺失字段与默认值](#可选值缺失字段与默认值)  
   - 5.1 [类型兼容的容错解码](#类型兼容的容错解码)  
   - 5.2 [@Default 属性包装器](#default-属性包装器)  
6. [枚举解析与回退策略](#枚举解析与回退策略)  
7. [日期、Data 与 KeyStrategy](#日期data-与-keystrategy)  
8. [自定义编解码：进阶技巧](#自定义编解码进阶技巧)  
   - 8.1 [泛型响应](#泛型响应)  
   - 8.2 [多态模型](#多态模型)  
9. [结语](#结语)  

---

## Codable 简介

`Codable` 是 Swift 4 引入的协议组合，等价于 `Encodable & Decodable`。只要让自定义类型遵循 `Codable`，Swift 编译器即可 **自动合成** JSON / Property-list 的编解码代码，免去了早期手写 `init(from:)` / `encode(to:)` 的大量样板。  

> ✅ **场景**：网络层 JSON ↔︎ Model、持久化、本地缓存、跨进程消息

## 与 HandyJSON 的差异
大多数项目中使用HandyJson作为序列化方案，因为使用方便，不需要考虑异常情况处理。但相较于 HandyJSON 依赖 Mirror 与 Objective-C Runtime 的反射机制、在编译期几乎不进行类型检查且遇到错配时常以 Any 兜底的“弱类型”方案，Codable 由 Swift 官方维护，采用编译期自动合成编解码逻辑，无需额外运行时注入，既避免了反射带来的性能开销，也让所有字段在编译阶段就能获得严格的类型安全保障；同时，Codable 纯值语义实现让大对象的 JSON 解析更高效、更易优化。综合 性能、类型安全 与 长期维护 三大维度，Codable 显著优于依赖第三方维护且潜在风险更多的 HandyJSON，因此在现代 iOS 项目中，使用 Codable 并逐步弃用 HandyJSON 是更可持续、可靠的选择。

> **Tips**  
> - HandyJSON 的反射式实现里，JSON 字段与模型属性类型不一致时，尝试用 Any 或默认值把解析继续做完。
> - 当我们说 “Codable 纯值语义实现更高效” 时，强调的是在大多数 JSON-Model 场景下，推荐用 struct（值类型）承载数据——能最大化编译期优化、减少 ARC 与指针跳转，让解析大 JSON 更快、更省内存。


## 最小可用示例

```
struct User: Codable {
    let id: Int
    var username: String
    var age: Int?
}

let json = "{\"id\":1,\"username\":\"Tom\",\"age\":21}".data(using: .utf8)!
let user = try? JSONDecoder().decode(User.self, from: json)
```
无需实现任何函数，`User` 即可在编译期获得自动合成的 `init(from:)` 与 `encode(to:)`。

字段映射：CodingKeys
---------------
后端接口常使用 `snake_case(下划线分隔)`，而 Swift 倾向于 `camelCase(驼峰)`。可通过:
```
struct User: Codable {
    var userId: Int
    var userName: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
    }
}
```
如果全局皆为 snake_case，可以让 `JSONDecoder` 使用 `keyDecodingStrategy = .convertFromSnakeCase`，省去逐字段编写 `CodingKeys`。
```
struct User: Codable {
  let userId: Int
  var userName: String
  var age: Int?
}
let json = "{\"user_id\":1,\"user_name\":\"Tom\", \"age\":21}".data(using: .utf8)!
      
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
decoder.dateDecodingStrategy = .iso8601
      
let user = try? decoder.decode(User.self, from: json)
```
## 可选值、缺失字段与默认值
### 类型兼容的容错解码
后端有时把数值字段当字符串返回，或反之。直接 `decode(Int.self, forKey: ...)` 遇到类型错配会抛错甚至导致 `try?` 解码为 `nil`。可通过 **KeyedDecodingContainer 扩展**兼容多种物理类型:
```
extension KeyedDecodingContainer {
    
    func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
        if let intValue = try? decode(Int.self, forKey: key) {
            return intValue
        }

        if let stringValue = try? decode(String.self, forKey: key),
           let intFromString = Int(stringValue) {
            return intFromString
        }
        return nil
    }
}
```
比如，下面的demo代码中，json字符串  `age`是字符串，`User`模型中`age`是`Int`类型
```
struct User: Codable {
  let id: Int
  var username: String
  var age: Int?
}
let json = "{\"id\":1,\"username\":\"Tom\",\"age\":\"21\"}".data(using: .utf8)!

let user = try? JSONDecoder().decode(User.self, from: json)

```

> **Tips**  
>  在绝大多数，Codable 的自动合成已经足够。属性类型的格式多变，比如:可以是Int、String、Int，以及动态不确定的情况，建议手写 init(from:)解码，（往往还要配对写 encode(to:)）。

### @Default 属性包装器

如果接口缺少某字段，Swift 默认会抛错；若字段标记为可选则变成 `nil`，但业务经常希望有 **合理默认值**。通过属性包装器封装一次即可：

```
protocol DefaultValue { 
    associatedtype Value: Codable
    static var defaultValue: Value { get } 
}

@propertyWrapper
struct Default<T: DefaultValue>: Codable {
    var wrappedValue: T.Value
}

extension Default: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = (try? container.decode(T.Value.self)) ?? T.defaultValue
    }
}

extension KeyedDecodingContainer {
  func decode<T>( _ type: Default<T>.Type, forKey key: Key) throws -> Default<T> where T: DefaultValue {
    try decodeIfPresent(type, forKey: key) ?? Default(wrappedValue: T.defaultValue)
   }
}

extension String {
    enum Empty: DefaultValue {
        static let defaultValue = ""
    }
    enum Zero: DefaultValue {
        static let defaultValue = "0"
    }
}

extension Int {
    enum Zero: DefaultValue {
        static let defaultValue = 0
    }
}

extension Bool {
    enum False: DefaultValue {
        static let defaultValue = false
    }
    enum True: DefaultValue {
        static let defaultValue = true
    }
}

extension Double {
    enum Zero: DefaultValue {
        static let defaultValue = 0.0
    }
}

extension Default {
    typealias True = Default<Bool.True>
    typealias False = Default<Bool.False>
    typealias EmptyString = Default<String.Empty>
    typealias ZeroString = Default<String.Zero>
    typealias ZeroDouble = Default<Double.Zero>
}

```
在下面的Demo代码中，`json`字符串中，只有2个字段，但`User`模型，却有6个字段，我们通过属性包装器添给相应字段加了默认值，如果不添加，Swift 默认会抛错。
```
struct User: Codable {
    let id: Int
    var username: String
    
    var age: Int?
    
    @Default.EmptyString
    var city: String
    
    @Default.True
    var gender: Bool
    
    @Default<Int.Zero>
    var count: Int
}

let json = "{\"id\":1,\"username\":\"Tom\"}".data(using: .utf8)!
let user = try? JSONDecoder().decode(User.self, from: json)

```


> **Tips**  
> - 建议为常用默认值（`0`、`""`、`false` 等）列出 TypeAlias，方便复用。  
> - 避免盲目把所有字段设为可选并在业务层解包，集中在模型层兜底更安全。

## 枚举解析与回退策略

新增服务端枚举值，老版本 App 解析时会崩溃。解决思路：为枚举声明**默认 case**，在解码失败时兜底。

```
protocol CodableEnumeration: RawRepresentable, Codable where RawValue: Codable {
    static var defaultCase: Self { get }
}

extension CodableEnumeration {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let decoded = try container.decode(RawValue.self)
            self = Self.init(rawValue: decoded) ?? Self.defaultCase
        } catch {
            self = Self.defaultCase
        }
    }
}

```
下面的demo代码中，`Json`中`gender`为2，但`Gender `枚举并没有定义对应的枚举值，于是解析成了`unknown `。
```
enum Gender: Int, CodableEnumeration {
    case unknown = -1
    case male = 0
    case female = 1
    
    static let defaultCase: Self = .unknown
}

struct User: Codable {
    let id: Int
    var username: String
    
    var age: Int?
    
    var gender: Gender
    
    @Default.EmptyString
    var city: String
    
    @Default<Int.Zero>
    var count: Int
}
let json = "{\"id\":1,\"username\":\"Tom\", \"gender\": 2}".data(using: .utf8)!
let user = try? JSONDecoder().decode(User.self, from: json)
```

## 日期、Data 与 KeyStrategy

- **DateDecodingStrategy**  
当用 JSONDecoder 把 JSON 里的时间字段解码成 Date 时，可以告诉解码器 “这个字段的格式是什么”
  - `.iso8601`：标准 RFC-3339 
  - `.secondsSince1970` / `.millisecondsSince1970`  
  - `.formatted(DateFormatter)`——完全自定义  
- **DataDecodingStrategy**  
决定JSON 里的那段内容要如何还原成 Swift 的 Data，常用的策略只有两个
  - `.base64` ——默认
  - `.custom`——自定义解析策略
- **keyDecodingStrategy / EncodingStrategy**  
驼峰和下划线编解码时的一对互逆策略
  - `.convertFromSnakeCase` ↔ `.convertToSnakeCase`

示例：
日期解析
```
    let jsonISO   = #"{"created_at":"2025-06-07T12:34:56Z"}"#.data(using: .utf8)!
    let jsonSecs  = #"{"created_at":1720353296}"#.data(using: .utf8)!
    let jsonCustom = #"{"created_at":"07/06/2025 12:34"}"#.data(using: .utf8)!
    struct Payload: Codable { let createdAt: Date }
    
    let dec = JSONDecoder()
    dec.keyDecodingStrategy = .convertFromSnakeCase
    //  ISO-8601
    dec.dateDecodingStrategy = .iso8601
    print(try? dec.decode(Payload.self, from: jsonISO).createdAt)

    // 秒
    dec.dateDecodingStrategy = .secondsSince1970
    print(try? dec.decode(Payload.self, from: jsonSecs).createdAt)

    // 自定义格式
    let f = DateFormatter()
    f.dateFormat = "dd/MM/yyyy HH:mm"
    f.locale = Locale(identifier: "en_US_POSIX")
    f.timeZone = TimeZone(secondsFromGMT: 0)
    dec.dateDecodingStrategy = .formatted(f)
    print(try? dec.decode(Payload.self, from: jsonCustom).createdAt)

```
Data解析
```
// 1.base64
struct Avatar: Codable { let raw: Data }
let json = "{\"raw\":\"R0lGODlhAQABAIAAAACwAAAAAAQABAAA\"}".data(using: .utf8)!
let avatar = try? JSONDecoder().decode(Avatar.self, from: json)  // 默认.base64

// 2.自定义解析Data
struct Payload: Codable { let blob: Data }

let dec = JSONDecoder()
dec.dataDecodingStrategy = .custom { decoder in
    let container = try decoder.singleValueContainer()
    let hex = try container.decode(String.self)
    guard let data = Data(hexString: hex) else {
        throw DecodingError.dataCorruptedError(in: container,
            debugDescription: "Hex string is invalid")
    }
    return data
}

let json1 = "{\"blob\":\"48656c6c6f\"}".data(using: .utf8)!
let obj1  = try? dec.decode(Payload.self, from: json1)

```

## 自定义编解码：进阶技巧
### 泛型响应

在许多网络层封装中，常见的做法是使用泛型结构体作为响应模型，例如：
```
struct ApiResponse<T: Codable>: Codable {
    var code: Int
    var message: String
    var data: T?
}
```
当泛型参数 T 遵循 Codable 协议时，Swift 的编解码机制能够自动完成嵌套对象的递归解析，几乎无需手动干预
比如:
```
enum ErrorCode :Int, Codable {
    case Success = 0
    
    case Failed = -1
}

struct ApiCustomResponse<T: Codable>: Codable {
    var code: ErrorCode = .Failed
    var message: String?
    var data: T?
}

struct User: Codable {
  let id: Int
  var username: String
  var age: Int?
}

class NetWork {
   static func request<T: Codable>(_ modelType: T.Type = T.self) throws -> T {
       let json = "{\"code\":0, \"data\":{\"id\":1,\"username\":\"Tom\",\"age\":21}}".data(using: .utf8)!
       return try JSONDecoder().decode(modelType, from: json)
    }
}

do {
    let user = try NetWork.request(ApiCustomResponse<User>.self)
    print("\(user)")
} catch {
    print("\(error)")
}

```
示例中 JSON 字符串被成功解码为` ApiCustomResponse<User> `实例，data 字段为具体业务模型
## 多态模型
若 `data` 字段根据 `kind` 不同返回不同子结构，可在 `init(from:)` 中先 decode `kind` 再 switch 动态 decode —— Swift 5.9 引入 **any Codable** 将进一步简化。

如下示例代码:同一个 data 节点会因为 kind 不同而呈现 完全不同的内部结构；在 init(from:) 里 先解标签再 switch，手动调用相应的 decode(SubType.self, …)
```

enum Kind: String, Codable { case photo, video, audio }

protocol Media: Codable {}

struct Photo: Media  { let url: URL; let width: Int; let height: Int }
struct Video: Media  { let url: URL; let duration: Double; let codec: String }
struct Audio: Media  { let url: URL; let bitrate: Int }

struct Wrapper: Codable {
    let kind: Kind
    let data: Media          // ← 不同子类型都实现 Media

    enum CodingKeys: String, CodingKey { case kind, data }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        kind = try c.decode(Kind.self, forKey: .kind)

        switch kind {
        case .photo:
            data = try c.decode(Photo.self, forKey: .data)
        case .video:
            data = try c.decode(Video.self, forKey: .data)
        case .audio:
            data = try c.decode(Audio.self, forKey: .data)
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(kind, forKey: .kind)

        switch data {
        case let p as Photo: try c.encode(p, forKey: .data)
        case let v as Video: try c.encode(v, forKey: .data)
        case let a as Audio: try c.encode(a, forKey: .data)
        default:
            throw EncodingError.invalidValue(data,
                .init(codingPath: c.codingPath, debugDescription: "Unknown media type"))
        }
    }
}

```

结语
--

`Codable` 并非“能用即止”的黑盒。深入理解其自动合成规则、容错边界与自定义扩展点后，可以大幅提升 **稳定性** 与 **代码可维护性**。借助属性包装器与协议抽象，将解码 *策略* 前置到 Model 层，实现“**上游正确，下游简单**”。
