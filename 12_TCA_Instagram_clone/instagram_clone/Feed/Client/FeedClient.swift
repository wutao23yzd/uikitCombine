//
//  FeedClient.swift
//  instagram_clone
//
//  Created by admin on 2025/6/19.
//

import Foundation
import ComposableArchitecture
import Combine

struct FeedClient {
    var fetch: @Sendable () async throws -> [Post]
}

private enum FeedClientKey: DependencyKey {
    static let liveValue: FeedClient = .mock
}

extension DependencyValues {
    var feedClient: FeedClient {
        get { self[FeedClientKey.self] }
        set { self[FeedClientKey.self] = newValue }
    }
}

extension FeedClient {
    static let mock: Self = {
        return .init {
            try await Task.sleep(nanoseconds: 300 * 1_000_000)
            return Post.MOCK_POSTS
        }
    }()
}
