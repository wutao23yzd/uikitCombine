//
//  LoginView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/11.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct LoginReducer {
    
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var password: String = ""
        var isLoading = false
        var error: String?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loginButtonTapped
        case loginResponse(Result<User, AuthError>)
        case signUpTapped
    }
    
    enum CancelID { case login }
    
    @Dependency(\.authClient) var authClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .loginButtonTapped:
                guard !state.isLoading else { return .none }
                state.isLoading = true
                return .run { [email = state.email, password = state.password] send in
                    let result = await Result { try await self.authClient.login(email, password) }
                        .mapError { error -> AuthError in
                            return error as? AuthError ?? .serverError
                    }
                    await send(.loginResponse(result))
                }
                .cancellable(id: CancelID.login, cancelInFlight: true)
            case let .loginResponse(.success(user)):
                state.isLoading = false
                return .none
            case let .loginResponse(.failure(error)):
                state.isLoading = false
                return .none
            default:
                return .none
            }
        }
    }
}

struct LoginView: View {
    @Bindable var store: StoreOf<LoginReducer>
    init(store: StoreOf<LoginReducer>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("instagram_text_logo")
                    .resizable()
                    .frame(width: 200, height: 120)
                
                VStack {
                    TextField("请输入邮箱", text: $store.email)
                        .font(.system(size: 16))
                        .padding(12)
                        .background(Color(.systemGray6))
                        .autocapitalization(.none)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                    
                    
                    TextField("请输入密码", text: $store.password)
                        .font(.system(size: 16))
                        .padding(12)
                        .background(Color(.systemGray6))
                        .autocapitalization(.none)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                }
                
                Button {
                    
                } label: {
                    Text("忘记密码？")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.trailing)
                }.frame(maxWidth: .infinity, alignment: .trailing)
                
                Button {
                    store.send(.loginButtonTapped)
                } label: {
                    Text("登录").font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color(.white))
                        .frame(width: 360, height: 44)
                        .background(Color(.blue))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(store.state.isLoading)
                .padding(.vertical)
                
                HStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width/2 - 40,height: 0.5)
                    
                    Text("或")
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width/2 - 40,height: 0.5)
                }.foregroundStyle(Color.gray)
                
                Button {
                    
                } label: {
                    Image("fb_login")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("使用Facebook登录")
                        .font(.system(size: 14, weight: .semibold))
                }
                Spacer()
                
                Divider()
                
                Button {
                    self.store.send(.signUpTapped)
                    
                } label: {
                    HStack {
                        Text("还没有账号?").font(.system(size: 13))
                        Text("注册").font(.system(size: 13, weight: .bold))
                    }
                    .foregroundStyle(Color(.systemBlue))
                    .padding(.vertical, 16)
                }
            }
        }
    }
}

#Preview {
    LoginView(store: Store(initialState: LoginReducer.State(), reducer: {
        LoginReducer()
    }))
}
