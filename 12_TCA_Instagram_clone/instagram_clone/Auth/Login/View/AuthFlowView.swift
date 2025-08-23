//
//  AuthFlowView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/27.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AuthFlowReducer {
    
    @Reducer
    struct PathReducer {
        enum State {
            case addEmail(AddEmailViewReducer.State)
            case createPassword(CreatePasswordReducer.State)
            case complete(CompleteAuthReducer.State)
        }
        
        enum Action {
            case addEmail(AddEmailViewReducer.Action)
            case createPassword(CreatePasswordReducer.Action)
            case complete(CompleteAuthReducer.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.addEmail,       action: \.addEmail)       { AddEmailViewReducer() }
            Scope(state: \.createPassword, action: \.createPassword) { CreatePasswordReducer() }
            Scope(state: \.complete,       action: \.complete)       { CompleteAuthReducer() }
        }
    }
    
    @ObservableState
    struct State {
        var login = LoginReducer.State()
        var path = StackState<PathReducer.State>()
        init() {}
    }
    
    enum Action {
        case login(LoginReducer.Action)
        case path(StackAction<PathReducer.State, PathReducer.Action>)
        
        case delegate(Delegate)
        enum Delegate { case didLogin(User) }
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.login,        action: \.login)        { LoginReducer() }
        
        Reduce { state, action in
            switch action {
            case .login(.signUpTapped):
                state.path.append(.addEmail(.init()))
                return .none
            case .login(.loginResponse(.success(let user))):
                return .send(.delegate(.didLogin(user)))
            case .path(.element(id: _, action: .addEmail(.delegate(.didEnterEmail(let email))))):
                state.path.append(.createPassword(.init(email: email)))
                return .none
            case .path(.element(id: _, action: .createPassword(.delegate(.didEnterPassword(let pwd, let email))))):
                state.path.append(.complete(.init(email: email, password: pwd)))
                return .none
            case .path(.element(id: _, action: .complete(.delegate(.didFinish(let user))))):
                return .send(.delegate(.didLogin(user)))
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) { PathReducer() }
    }
}

struct AuthFlowView: View {
    let store: StoreOf<AuthFlowReducer>
    
    var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action:\.path)
        ) {
            LoginView( store: store.scope(state: \.login, action: \.login) )
        } destination: { state in
            switch state {
            case .addEmail:
                CaseLet(\AuthFlowReducer.PathReducer.State.addEmail, action: AuthFlowReducer.PathReducer.Action.addEmail) {
                    AddEmailView(store: $0)
                        .navigationBarBackButtonHidden(true)
                }
            case .createPassword:
                CaseLet(\AuthFlowReducer.PathReducer.State.createPassword, action: AuthFlowReducer.PathReducer.Action.createPassword) {
                    CreatePasswordView(store: $0)
                        .navigationBarBackButtonHidden(true)
                }
            case .complete:
                CaseLet(\AuthFlowReducer.PathReducer.State.complete, action: AuthFlowReducer.PathReducer.Action.complete) {
                    CompleteAuthView(store: $0)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    AuthFlowView(store: Store(initialState: AuthFlowReducer.State(), reducer: {
        AuthFlowReducer()
    }))
}
