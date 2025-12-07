import Foundation
import AWELaunchKit

// MARK: - UserService

public protocol UserService {
    var isLoggedIn: Bool { get }
    var userName: String? { get }
    
    func login(name: String, completion: @escaping (Bool) -> Void)
}

public final class DefaultUserService: UserService {
    public private(set) var isLoggedIn: Bool = false
    public private(set) var userName: String?
    
    public init() {}
    
    public func login(name: String, completion: @escaping (Bool) -> Void) {
        self.isLoggedIn = true
        self.userName = name
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(true)
        }
    }
}

// MARK: - NetworkClient

public protocol NetworkClient {
    func request(path: String,
                 query: [String: String],
                 completion: @escaping (Result<[String], Error>) -> Void)
}

public enum DemoNetworkError: Error {
    case notImplemented
}

public final class StubNetworkClient: NetworkClient {
    public init() {}
    
    public func request(path: String,
                        query: [String : String],
                        completion: @escaping (Result<[String], Error>) -> Void) {
        let keyword = query["q"] ?? ""
        let results = (1...5).map { "Result \($0) for \(keyword)" }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            completion(.success(results))
        }
    }
}

// MARK: - InfraBootTask & 注册函数

public final class InfraBootTask: BootTask {
    public override func execute(completion: @escaping () -> Void) {
        let userService = DefaultUserService()
        let network = StubNetworkClient()
        
        ServiceRegistry.shared.register(UserService.self, impl: userService)
        ServiceRegistry.shared.register(NetworkClient.self, impl: network)
        
        completion()
    }
}

/// 宿主 / Shell 需要显式调用，用于注册中台 BootTask
public func registerInfraBootTasks() {
    LaunchKit.register(task: InfraBootTask(phase: .infra, priority: 100))
}

