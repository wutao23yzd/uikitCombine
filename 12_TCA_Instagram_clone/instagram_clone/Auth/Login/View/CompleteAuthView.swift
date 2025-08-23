//
//  CompleteAuthView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CompleteAuthReducer {
    
    @ObservableState
    struct State {
        var email: String
        var password: String
        var isLoading = false
        var error: String?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case completeButtonTapped
        case loginResponse(Result<User, AuthError>)
        
        case delegate(Delegate)
        enum Delegate { case didFinish(User) }
    }
    
    enum CancelID { case login }
    @Dependency(\.authClient) var authClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .completeButtonTapped:
                guard !state.isLoading else { return .none }
                state.isLoading = true
                return .run { [email = state.email, password = state.password] send in
                    let result = await Result { try await authClient.login(email, password) }
                        .mapError { $0 as? AuthError ?? .serverError }
                    await send(.loginResponse(result))
                }
            case .loginResponse(.success(let user)):
                state.isLoading = false
                return .send(.delegate(.didFinish(user)))
            case .loginResponse(.failure(let err)):
                state.isLoading = false
                state.error = err.localizedDescription
                return .none
            default:
                return .none
            }
        }
    }
}

struct CompleteAuthView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var store: StoreOf<CompleteAuthReducer>
    init(store: StoreOf<CompleteAuthReducer>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            Text("欢迎来到App")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("点击下面的按钮完成注册并开始使用App")
                .font(.footnote)
            
            Button {
                self.store.send(.completeButtonTapped)
            } label: {
                Text("完成注册")
                    .font(Font.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.top)
            
            Spacer()

        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

//#Preview {
//    CompleteAuthView(store: Store(initialState: CompleteAuthReducer.State(), reducer: {
//        CompleteAuthReducer()
//    }))
//}
