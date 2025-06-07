//
//  ViewController.swift
//  codableDemo
//
//  Created by admin on 2025/6/7.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        demo1()
        //demo2()
        //demo3()
        //demo4()
        //demo5()
        //demo6()
        //demo7()
        //demo8()
        //demo9()
    }


}

// 正常
func demo1() {
    
    struct User: Codable {
        let id: Int
        var username: String
        var age: Int?
    }

    let json = "{\"id\":1,\"username\":\"Tom\",\"age\":21}".data(using: .utf8)!
    let user = try? JSONDecoder().decode(User.self, from: json)
    
    print("user--\(String(describing: user))")
}

// 字段映射：CodingKeys
func demo2() {
    struct User: Codable {
        var userId: Int
        var userName: String

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case userName = "user_name"
        }
    }

    let json = "{\"user_id\":1,\"user_name\":\"Tom\", \"age\":21}".data(using: .utf8)!
    let user = try? JSONDecoder().decode(User.self, from: json)
    
    print("user--\(String(describing: user))")
}

// 全局映射 下划线-》转驼峰
func demo3() {
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
    
    print("user--\(String(describing: user))")
}

// 类型兼容的容错解码 ,age string -> Int
func demo4() {
    
    struct User: Codable {
      let id: Int
      var username: String
      var age: Int?
    }
    let json = "{\"id\":1,\"username\":\"Tom\",\"age\":\"21\"}".data(using: .utf8)!

    let user = try? JSONDecoder().decode(User.self, from: json)
    
    print("user--\(String(describing: user))")
    
}

// @Default 属性包装器
func demo5() {
    
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
    
    print("user--\(String(describing: user))")
    
}

// 枚举默认值
func demo6() {
    
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
    
    print("user--\(String(describing: user))")
    
}
// 时间
func demo7() {
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
}

// 解析data
func demo8() {
    // 1. base64解析
    struct Avatar: Codable { let raw: Data }
    let json = "{\"raw\":\"R0lGODlhAQABAIAAAACwAAAAAAQABAAA\"}".data(using: .utf8)!
    let avatar = try? JSONDecoder().decode(Avatar.self, from: json)  // 默认.base64
    
    
    print("")
    // 2.自定义解析
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
    
    print("")
}

func demo9() {
    
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
}


extension Data {
    init?(hexString: String) {
        let bytes = stride(from: 0, to: hexString.count, by: 2).compactMap {
            UInt8(hexString.dropFirst($0).prefix(2), radix: 16)
        }
        guard bytes.count * 2 == hexString.count else { return nil }
        self.init(bytes)
    }
}
