import Foundation

protocol DefaultValue {
    associatedtype Value: Codable
    static var defaultValue: Value { get }
}

protocol CodableEnumeration: RawRepresentable, Codable where RawValue: Codable {
    static var defaultCase: Self {get}
}

@propertyWrapper
struct Default<T: DefaultValue> {
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

extension Default {
    typealias True = Default<Bool.True>
    typealias False = Default<Bool.False>
    typealias EmptyString = Default<String.Empty>
    typealias ZeroString = Default<String.Zero>
    typealias ZeroDouble = Default<Double.Zero>
}

extension Bool {
    enum False: DefaultValue {
        static let defaultValue = false
    }
    enum True: DefaultValue {
        static let defaultValue = true
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

extension Double {
    enum Zero: DefaultValue {
        static let defaultValue = 0.0
    }
}

extension Int {
    enum Zero: DefaultValue {
        static let defaultValue = 0
    }
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
