//
//  FeedCell.swift
//  instagram_clone
//
//  Created by admin on 2025/6/19.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct FeedItemReducer {
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: Post.ID
        var post: Post
    }
    
    enum Action {
        case likeButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .likeButtonTapped:
                return .none
            }
        }
    }
}

struct FeedCell: View {
    let store: StoreOf<FeedItemReducer>
    var body: some View {
        VStack {
            HStack {
                if let user = store.state.post.user {
                    CircularProfileImageView(imageUrl: user.profileImageUrl, dimension: 40)
                    Text(user.username)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding(.leading)
            
            Image(store.post.imageUrl)
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .clipShape(Rectangle())
            
            
            HStack(spacing: 16) {
                Button {
                    
                } label: {
                    Image(systemName: "heart")
                        .imageScale(.large)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "bubble.right")
                        .imageScale(.large)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                }
                
                Spacer()
            }
            .padding(.leading, 8)
            .padding(.top, 4)
            .foregroundStyle(Color.black)
            
            Text("\(store.post.likes)个点赞")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                .padding(.top, 1)
            
            HStack {
                Text(store.post.user?.username ?? "").fontWeight(.semibold) + Text(store.post.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.footnote)
            .padding(.leading, 10)
            .padding(.top, 1)
            
            Text("6小时前")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.top, 1)
                .foregroundStyle(.gray)
        }
    }
}

//#Preview {
//    FeedCell(store: Store(initialState: FeedItemReducer.S, reducer: <#T##() -> Reducer#>))
//}
