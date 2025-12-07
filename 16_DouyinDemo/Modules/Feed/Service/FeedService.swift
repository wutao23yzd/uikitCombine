import Foundation
import AWESearch  // 只是为了识别 SearchEntryProtocol 类型
import AWELaunchKit
import AWEInfra

public protocol FeedServiceProtocol {
   
    func loadFeedItems() -> [String]
    
    func searchEntry() -> SearchEntryProtocol?
}

public final class OnlineFeedService: FeedServiceProtocol {
    
    private let userService: UserService?
    
    public init(userService: UserService?) {
        self.userService = userService
    }
    
    public func loadFeedItems() -> [String] {
        let userName = userService?.userName ?? "Guest"
        return (1...20).map { "Feed Item \($0) for \(userName)" }
    }
    
    public func searchEntry() -> SearchEntryProtocol? {
        ServiceRegistry.shared.resolve(SearchEntryProtocol.self)
    }
}

public final class MockFeedService: FeedServiceProtocol {
    
    public init() {}
    
    public func loadFeedItems() -> [String] {
        (1...10).map { "[MOCK] Feed Item \($0)" }
    }
    
    public func searchEntry() -> SearchEntryProtocol? {
        ServiceRegistry.shared.resolve(SearchEntryProtocol.self)
    }
}
