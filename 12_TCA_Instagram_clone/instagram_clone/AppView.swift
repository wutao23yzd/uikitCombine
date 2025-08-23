//
//  AppView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/16.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AppReducer {
    enum State {
        case unauthenticated(AuthFlowReducer.State)
        case authenticated(MainTableReducer.State)
    }
    
    enum Action {
        case unauthenticated(AuthFlowReducer.Action)
        case authenticated(MainTableReducer.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.unauthenticated, action: \.unauthenticated) { AuthFlowReducer() }
        Scope(state: \.authenticated,   action: \.authenticated)   { MainTableReducer() }

        Reduce { state, action in
            switch action {
            case .unauthenticated(.delegate(.didLogin(let user))):
                state = .authenticated(.init(authenticatedUser: user))
                return .cancel(id: LoginReducer.CancelID.login)
            case .authenticated(.logoutButtonTapped):
                state = .unauthenticated(.init())
                return .none
            default:
                return .none
            }
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppReducer>

    var body: some View {
        SwitchStore(self.store) { initialState in
            switch initialState {
            case .unauthenticated:
                CaseLet(\AppReducer.State.unauthenticated, action: AppReducer.Action.unauthenticated) {
                    AuthFlowView(store: $0)
                }
            case .authenticated:
                CaseLet(\AppReducer.State.authenticated, action: AppReducer.Action.authenticated) {
                    MainTabView(store: $0)
                }
            }
        }
    }
}


#Preview {
    AppView(
        store: Store(initialState: AppReducer.State.unauthenticated(AuthFlowReducer.State())) {
            AppReducer()
        }
    )
}
