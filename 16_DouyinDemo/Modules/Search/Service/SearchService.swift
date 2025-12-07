import Foundation
import AWEInfra

public protocol SearchServiceProtocol {
    func search(keyword: String,
                completion: @escaping (Result<[SearchResult], Error>) -> Void)
}

public final class OnlineSearchService: SearchServiceProtocol {
    private let network: NetworkClient
    
    public init(network: NetworkClient) {
        self.network = network
    }
    
    public func search(keyword: String,
                       completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        network.request(path: "/search", query: ["q": keyword]) { result in
            switch result {
            case .success(let strings):
                let models = strings.map { SearchResult(title: $0) }
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

public final class MockSearchService: SearchServiceProtocol {
    public init() {}
    
    public func search(keyword: String,
                       completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        // 纯本地假数据，不依赖网络
        let models = (1...5).map {
            SearchResult(title: "[MOCK] Result \($0) for \(keyword)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completion(.success(models))
        }
    }
}
