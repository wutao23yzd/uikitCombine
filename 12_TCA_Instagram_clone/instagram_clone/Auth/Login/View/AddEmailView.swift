//
//  AddEmailView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AddEmailViewReducer {
    
    @ObservableState
    struct State {
        var email: String = ""
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
        case delegate(Delegate)
        enum Delegate { case didEnterEmail(String) }
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .nextButtonTapped:
                return .send(.delegate(.didEnterEmail(state.email)))
            default:
                return .none
            }
        }
    }
}


struct AddEmailView: View {
    @Bindable var store: StoreOf<AddEmailViewReducer>
    @Environment(\.dismiss) var dismiss
    init(store: StoreOf<AddEmailViewReducer>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("添加你的邮箱")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text("你将使用这个邮箱来登录你的账号")
                .font(.footnote)
                .foregroundStyle(.gray)
                .padding(.bottom, 10)
            
            TextField("输入邮箱", text: $store.email)
                .font(Font.system(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button {
                self.store.send(.nextButtonTapped)
            } label: {
                Text("下一步")
                    .font(Font.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.top)

            
            Spacer()
            
        }
        .padding(.horizontal, 16)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
                    
            }
        }
    }
}

#Preview {
    AddEmailView(store: Store(initialState: AddEmailViewReducer.State(), reducer: {
        AddEmailViewReducer()
    }))
}
