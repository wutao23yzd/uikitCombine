//
//  FeedView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/18.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct FeedViewReducer {
    
    @Reducer(state: .equatable)
    enum Destination {
        case upload(UploadPostReducer)
    }
    
    @ObservableState
    struct State: Equatable {
        var upload: UploadPostReducer.State = UploadPostReducer.State()
        var posts: IdentifiedArrayOf<FeedItemReducer.State> = []
        var isLoading = false
        
        @Presents var destination: Destination.State?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case didTap
        case posts(IdentifiedActionOf<FeedItemReducer>)
        case response(Result<[Post], Error>)
        case upload(UploadPostReducer.Action)

        case onTapPostBtn
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Dependency(\.feedClient) var feedClient
    
    var body: some Reducer<State, Action> {        
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        let posts = try await feedClient.fetch()
                        await send(.response(.success(posts)))
                    } catch {
                        await send(.response(.failure(error)))
                    }
                }
            case let .response(.success(posts)):
                state.posts = IdentifiedArray(uniqueElements: posts.map {
                    FeedItemReducer.State.init(id: $0.id, post: $0)
                })
                return .none
            case .destination(.presented(.upload(.clearPostDataAndReturnToFeed))):
                state.destination = nil
                return .none
            case .onTapPostBtn:
                state.destination = .upload(UploadPostReducer.State())
                return .none
            default:
                return .none
            
            }
        }
        .forEach(\.posts, action: \.posts) {
            FeedItemReducer()
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination.body
        }
    }
}

struct FeedView: View {
    @Bindable var store: StoreOf<FeedViewReducer>
    init(store: StoreOf<FeedViewReducer>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEachStore(store.scope(state: \.posts, action: \.posts)) { itemStore in
                        FeedCell(store: itemStore)
                    }
                }
                .padding(8)
            }
            .onAppear {
                store.send(.onAppear)
            }
            .navigationTitle("动态")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        store.send(.onTapPostBtn)
                    } label: {
                        Image(systemName: "paperplane")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(item: $store.scope(state: \.destination?.upload, action: \.destination.upload)) { itemStore in
                UploadPostView(store: itemStore)
            }
        }
    }
}

#Preview {
    FeedView(store: Store(initialState: FeedViewReducer.State(), reducer: {
        FeedViewReducer()
    }))
}
