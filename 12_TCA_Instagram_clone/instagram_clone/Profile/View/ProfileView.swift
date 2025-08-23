//
//  ProfileView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/18.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ProfileViewReducer {
    
    @ObservableState
    struct State: Equatable {
        var user: User
        
        var header: ProfileHeaderReducer.State {
            get { .init(user: user) }
            set { user = newValue.user }
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case header(ProfileHeaderReducer.Action)
        case logoutButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.header, action: \.header) {
            ProfileHeaderReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .header:
                return .none
            case .logoutButtonTapped:
                return .none
            }
        }
    }
}

struct ProfileView: View {
    @Bindable var store: StoreOf<ProfileViewReducer>
    init(store: StoreOf<ProfileViewReducer>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ProfileHeaderView(
                    store: store.scope(state: \.header, action: \.header)
                )
                PostGridView()
            }
            .navigationTitle("资料")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.logoutButtonTapped)
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        
    }
}

#Preview {
    ProfileView(store: Store(initialState: ProfileViewReducer.State(user: User.MOCK_USERS[0]), reducer: {
        ProfileViewReducer()
    }))
}
