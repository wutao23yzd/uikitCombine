//
//  ReelsView.swift
//  instagram_clone
//
//  Created by admin on 2025/7/7.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ReelsContainerReducer {
    @ObservableState
    struct State {
        var reelsViewState = ReelsViewReducer.State()
    }
    
    enum Action {
        case reelsView(ReelsViewReducer.Action)
    }
    
    @Dependency(\.videoClient) var videoClient
    
    var body: some Reducer<State, Action> {
        Scope(state: \.reelsViewState, action: \.reelsView) {
            ReelsViewReducer()
        }
    }
}

struct ReelsContainerView: View {
    let store: StoreOf<ReelsContainerReducer>
    init(store: StoreOf<ReelsContainerReducer>) {
        self.store = store
    }
    
    var body: some View{
        ZStack{
            ReelsView(store: store.scope(state: \.reelsViewState, action: \.reelsView))
        }
        .ignoresSafeArea()
    }
}

@Reducer
struct ReelsViewReducer {
    @ObservableState
    struct State {
        var feeds: IdentifiedArrayOf<ReelsContentReducer.State> = []
        var currentPlayingID: String?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case reelsContent(IdentifiedActionOf<ReelsContentReducer>)
        case fetchVideos
        case response(Result<[Video], Error>)
    }
    
    @Dependency(\.videoClient) var videoClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .fetchVideos:
                return .run { send in
                    do {
                        let videos = try await videoClient.fetch()
                        await send(.response(.success(videos)))
                    } catch {
                        await send(.response(.failure(error)))
                    }
                }
            case .binding:
                return .none
            case let .response(.success(videos)):
                state.feeds = IdentifiedArray(uniqueElements: videos.map {
                    ReelsContentReducer.State(id: $0.id, feed: $0)
                })
                state.currentPlayingID = videos.first?.id
                return .none
            default:
                return .none
            }
        }
        .forEach(\.feeds, action: \.reelsContent) {
          ReelsContentReducer()
        }
    }
}

struct ReelsView: View {
    
    @Bindable var store: StoreOf<ReelsViewReducer>
        
    init(store: StoreOf<ReelsViewReducer>) {
        self.store = store
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEachStore(store.scope(state: \.feeds, action: \.reelsContent)) { itemStore in
                    ReelsContentView(store: itemStore, currentPlayingID: $store.currentPlayingID)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $store.currentPlayingID)
        .scrollTargetBehavior(.paging)
       
        .onAppear {
            //currentPlayingID = feedData.first?.id
        }
        .task {
            await store.send(.fetchVideos).finish()
        }
        
    }
}

//#Preview {
//    ReelsView()
//}
