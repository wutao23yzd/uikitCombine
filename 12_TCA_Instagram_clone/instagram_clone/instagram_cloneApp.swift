//
//  instagram_cloneApp.swift
//  instagram_clone
//
//  Created by admin on 2025/6/11.
//

import SwiftUI
import ComposableArchitecture


@main
struct instagram_cloneApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(initialState: AppReducer.State.unauthenticated(AuthFlowReducer.State.init())) {
                    AppReducer()
                }
            )
        }
    }
}
