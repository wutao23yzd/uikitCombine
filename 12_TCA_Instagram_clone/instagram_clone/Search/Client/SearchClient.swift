//
//  SearchClient.swift
//  instagram_clone
//
//  Created by admin on 2025/6/24.
//

import Foundation
import ComposableArchitecture
import Combine

struct SearchClient {
    var search: @Sendable (_ text: String) async throws -> [User]
}

private enum SearchClientKey: DependencyKey {
    
    static var liveValue = SearchClient { text in
        let searchTxt = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return searchTxt.isEmpty ? User.MOCK_USERS : User.MOCK_USERS.filter { $0.username.contains(text) }
    }
}

extension DependencyValues {
    var searchClient: SearchClient {
        get { self[SearchClientKey.self] }
        set { self[SearchClientKey.self] = newValue }
    }
}
