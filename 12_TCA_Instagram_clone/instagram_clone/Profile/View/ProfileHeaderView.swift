//
//  ProfileHeaderView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ProfileHeaderReducer {
    
    @ObservableState
    struct State {
        var user: User
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}

struct ProfileHeaderView: View {
    @Bindable var store: StoreOf<ProfileHeaderReducer>
    init(store: StoreOf<ProfileHeaderReducer>) {
        self.store = store
    }
    
    var body: some View {
        HStack(spacing: 8) {
            CircularProfileImageView(imageUrl: nil, dimension: 40)
                
            Spacer()
            
            StatItemView(title: "关注", value: "0")
            
            StatItemView(title: "被关注", value: "0")
            
            StatItemView(title: "收藏", value: "0")
        }
        .padding(.horizontal)
        
        VStack(alignment: .leading, spacing: 4) {
            
            Text(store.user.fullname)
                .font(.footnote)
                .fontWeight(.semibold)
            
            if let bio = store.user.bio {
                Text(bio)
                    .font(.footnote)
            }
            
            Text(store.user.username)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)

        Button {
            
        } label: {
            Text("编辑资料")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 360, height: 32)
                .foregroundStyle(Color.black)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.gray, lineWidth: 1)
                }
        }
        
        Divider()
    }
}

#Preview {
    ProfileHeaderView(store: Store(initialState: ProfileHeaderReducer.State(user: User.MOCK_USERS[0]), reducer: {
        ProfileHeaderReducer()
    }))
}
