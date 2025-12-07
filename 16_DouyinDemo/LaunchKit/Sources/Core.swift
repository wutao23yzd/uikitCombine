import UIKit

// MARK: - BootPhase
public enum BootPhase: Int {
    case preInfra    = 0
    case infra       = 1
    case bizRegister = 2
    case postUI      = 3
}

// MARK: - BootTask

open class BootTask {
    public let phase: BootPhase
    public let priority: Int   // 同 phase 内，数值越大越先执行
    
    public init(phase: BootPhase, priority: Int = 0) {
        self.phase = phase
        self.priority = priority
    }
    
    open func execute(completion: @escaping () -> Void) {
        completion()
    }
}

// MARK: - LaunchKit

public enum LaunchKit {
    private static var tasks: [BootTask] = []
    private static var hasRunPhases = Set<BootPhase>()
    
    public static func register(task: BootTask) {
        tasks.append(task)
    }
    
    public static func run(phase: BootPhase, completion: @escaping () -> Void) {
        guard !hasRunPhases.contains(phase) else {
            completion()
            return
        }
        hasRunPhases.insert(phase)
        
        let phaseTasks = tasks
            .filter { $0.phase == phase }
            .sorted { $0.priority > $1.priority }
        
        runTasksSequentially(phaseTasks, index: 0, completion: completion)
    }
    
    private static func runTasksSequentially(_ phaseTasks: [BootTask],
                                             index: Int,
                                             completion: @escaping () -> Void) {
        guard index < phaseTasks.count else {
            completion()
            return
        }
        let task = phaseTasks[index]
        task.execute {
            runTasksSequentially(phaseTasks, index: index + 1, completion: completion)
        }
    }
}

// MARK: - ServiceRegistry (中台服务总线)

public final class ServiceRegistry {
    public static let shared = ServiceRegistry()
    
    private var store: [String: Any] = [:]
    private let lock = NSLock()
    
    private init() {}
    
    public func register<T>(_ type: T.Type, impl: T) {
        let key = String(reflecting: type)
        lock.lock()
        store[key] = impl
        lock.unlock()
    }
    
    public func resolve<T>(_ type: T.Type) -> T? {
        let key = String(reflecting: type)
        lock.lock()
        let value = store[key] as? T
        lock.unlock()
        return value
    }
}

// MARK: - Router

public final class Router {
    public static let shared = Router()
    
    public typealias RouteHandler = (_ params: [String: Any]?) -> UIViewController?
    
    private var routes: [String: RouteHandler] = [:]
    
    private init() {}
    
    public func register(_ path: String, handler: @escaping RouteHandler) {
        routes[path] = handler
    }
    
    public func viewController(for path: String,
                               params: [String: Any]? = nil) -> UIViewController? {
        return routes[path]?(params)
    }
    
    public func open(_ path: String,
                     from navigationController: UINavigationController?,
                     params: [String: Any]? = nil,
                     animated: Bool = true) {
        guard let vc = viewController(for: path, params: params) else { return }
        if let nav = navigationController {
            nav.pushViewController(vc, animated: animated)
        } else {
            UIApplication.shared.keyWindow?.rootViewController?
                .present(vc, animated: animated)
        }
    }
}

private extension UIApplication {
    var keyWindow: UIWindow? {
        return connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

