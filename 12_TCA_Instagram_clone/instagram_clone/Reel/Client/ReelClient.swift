//
//  ReelClient.swift
//  instagram_clone
//
//  Created by admin on 2025/7/8.
//

import Foundation
import ComposableArchitecture
import Combine

struct VideoClient {
    var fetch: @Sendable () async throws -> [Video]
}

private enum VideoClientKey: DependencyKey {
    static let liveValue: VideoClient = .mock
}

extension DependencyValues {
    var videoClient: VideoClient {
        set {
            self[VideoClientKey.self] = newValue
        }
        get {
            self[VideoClientKey.self]
        }
    }
}

extension VideoClient {
    static let mock: Self = {
        return .init {
            Video.MOCK_VIDEOS
        }
    }()
}
