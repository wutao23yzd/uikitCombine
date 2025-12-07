import UIKit
import AWELaunchKit
import AWEInfra

public final class FeedEntryImpl: FeedEntryProtocol {
    public init() {}
    
    public func makeRootViewController() -> UIViewController {
        // 优先从 ServiceRegistry 拿 FeedServiceProtocol 实现
        if let service = ServiceRegistry.shared.resolve(FeedServiceProtocol.self) {
            return FeedViewController(feedService: service)
        }
        
        // 如果没注册，实现一个默认 Online 版本
        let userService = ServiceRegistry.shared.resolve(UserService.self)
        let service = OnlineFeedService(userService: userService)
        return FeedViewController(feedService: service)
    }
}

public final class FeedServiceRegisterTask: BootTask {
    private let useMock: Bool
    
    public init(phase: BootPhase = .infra, priority: Int = 55, useMock: Bool) {
        self.useMock = useMock
        super.init(phase: phase, priority: priority)
    }
    
    public override func execute(completion: @escaping () -> Void) {
        if useMock {
            let service = MockFeedService()
            ServiceRegistry.shared.register(FeedServiceProtocol.self, impl: service)
        } else {
            let userService = ServiceRegistry.shared.resolve(UserService.self)
            let service = OnlineFeedService(userService: userService)
            ServiceRegistry.shared.register(FeedServiceProtocol.self, impl: service)
        }
        completion()
    }
}

public final class FeedBootTask: BootTask {
    public override func execute(completion: @escaping () -> Void) {
        let entry = FeedEntryImpl()
        ServiceRegistry.shared.register(FeedEntryProtocol.self, impl: entry)
        
        // 注册一个路由用于单独打开 Feed
        Router.shared.register("douyin://feed") { _ in
            entry.makeRootViewController()
        }
        
        completion()
    }
}

public func registerFeedBootTasks(useMockService: Bool = false) {
    LaunchKit.register(task: FeedServiceRegisterTask(useMock: useMockService))
    LaunchKit.register(task: FeedBootTask(phase: .bizRegister, priority: 40))
}

