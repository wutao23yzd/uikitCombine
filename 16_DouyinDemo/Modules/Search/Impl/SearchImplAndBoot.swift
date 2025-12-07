import UIKit
import AWELaunchKit
import AWEInfra

public final class SearchEntryImpl: SearchEntryProtocol {
    public init() {}
    
    public func makeSearchViewController() -> UIViewController {
        if let service = ServiceRegistry.shared.resolve(SearchServiceProtocol.self) {
            return SearchViewController(service: service)
        }
        
        if let network = ServiceRegistry.shared.resolve(NetworkClient.self) {
            let service = OnlineSearchService(network: network)
            return SearchViewController(service: service)
        }
        
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        vc.title = "Search (Service not available)"
        return vc
    }
}

public final class SearchServiceRegisterTask: BootTask {
    private let useMock: Bool
    
    public init(phase: BootPhase = .infra, priority: Int = 60, useMock: Bool) {
        self.useMock = useMock
        super.init(phase: phase, priority: priority)
    }
    
    public override func execute(completion: @escaping () -> Void) {
        // 线上实现需要网络能力
        if !useMock,
           let network = ServiceRegistry.shared.resolve(NetworkClient.self) {
            let service = OnlineSearchService(network: network)
            ServiceRegistry.shared.register(SearchServiceProtocol.self, impl: service)
        } else {
            // 子壳 / 调试环境可以选择 Mock 实现
            let service = MockSearchService()
            ServiceRegistry.shared.register(SearchServiceProtocol.self, impl: service)
        }
        
        completion()
    }
}

public final class SearchBootTask: BootTask {
    public override func execute(completion: @escaping () -> Void) {
        let entry = SearchEntryImpl()
        ServiceRegistry.shared.register(SearchEntryProtocol.self, impl: entry)
        
        Router.shared.register("douyin://search") { _ in
            entry.makeSearchViewController()
        }
        
        completion()
    }
}

/// 宿主 / Shell 需要调用，用于注册 Search 相关 BootTasks
public func registerSearchBootTasks(useMockService: Bool = false) {
    LaunchKit.register(task: SearchServiceRegisterTask(useMock: useMockService))
    LaunchKit.register(task: SearchBootTask(phase: .bizRegister, priority: 50))
}

