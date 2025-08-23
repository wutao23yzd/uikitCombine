//
//  CreatePasswordView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CreatePasswordReducer {
    
    @ObservableState
    struct State {
        var email: String = ""
        var pwd: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
        case delegate(Delegate)
        enum Delegate { case didEnterPassword(String, String) }
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .send(.delegate(.didEnterPassword(state.email, state.pwd)))
            case .binding:
                return .none
            default:
                return .none
            }
        }
    }
}


struct CreatePasswordView: View {
    
    @Environment(\.dismiss) var dimiss;
    
    @Bindable var store: StoreOf<CreatePasswordReducer>
    init(store: StoreOf<CreatePasswordReducer>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("创建密码")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text("密码长度至少包含6位")
                .font(.footnote)
                .foregroundStyle(.gray)
                .padding(.bottom, 10)
            
            SecureField("请输入密码", text: $store.pwd)
                .font(Font.system(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            Button {
                self.store.send(.nextButtonTapped)
            } label: {
                Text("下一步")
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
                        dimiss()
                    }
            }
        }
    }
}

#Preview {
    CreatePasswordView(store: Store(initialState: CreatePasswordReducer.State(), reducer: {
        CreatePasswordReducer()
    }))
}
