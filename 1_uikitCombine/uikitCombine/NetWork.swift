import Foundation
import Combine

enum ErrorCode :Int, Codable {
    case Success = 0
    
    case Failed = -1
}

enum EError {
    case cancelled
    case failure(String?,code:Int = -1, data:AnyObject? = nil)
}

extension EError : Error {
    public var errorCode:Int {
        switch self {
        case .failure(_,let code,_):
            return code
        default:
            return 0
        }
    }
    
    public var message: String? {
        switch self {
        case .failure(let msg,_,_):
            return msg
        default:
            return self.localizedDescription
        }
    }
    
}

struct ApiCustomResponse<T: Codable>: Codable {
    var code: ErrorCode = .Failed
    var message: String?
    var data: T?
}

struct UserModel: Codable, Equatable {
    var username: String
    var age: Int
    var city: String
}

class NetWork {
    
   static func request<T: Codable>(_ modelType: T.Type = T.self) -> AnyPublisher<T, Never> {
        Future<T, Never> { promise in
            guard let url = Bundle.main.url(forResource: "userInfo", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let model = try? JSONDecoder().decode(modelType, from: data) else {
                promise(.success(makeErrorModel(nil)))
                return
            }
            promise(.success(model))
        }
        .eraseToAnyPublisher()
    }
    
    static func makeErrorModel<T: Codable>(_ error: Error?) -> T {
        let raw = """
        {"code":\(ErrorCode.Failed),
         "data":"",
         "message":"数据请求失败",
         "success":false}
        """
        
        return try! JSONDecoder().decode(T.self, from: Data(raw.utf8))
    }
}
