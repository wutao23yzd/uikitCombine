//
//  NotificationClient.swift
//  instagram_clone
//
//  Created by admin on 2025/6/26.
//

import Foundation
import ComposableArchitecture
import Combine

struct NotificationClient {
    var fetch: @Sendable () async throws -> [Notification]
}

private enum NotificationClientKey: DependencyKey {
    static let liveValue: NotificationClient = .mock
}

extension DependencyValues {
    var notificationClient: NotificationClient {
        get { self[NotificationClientKey.self] }
        set { self[NotificationClientKey.self] = newValue }
    }
}

extension NotificationClient {
    static let mock: Self = {
        return .init {
            return Notification.MOCK_Notification
        }
    }()
}
