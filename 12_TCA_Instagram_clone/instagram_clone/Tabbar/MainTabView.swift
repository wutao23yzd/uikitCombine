//
//  MainTabView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/16.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MainTableReducer {
    enum Tab { case feed, search, reels, notification, profile }
    
    @ObservableState
    struct State {
        var currentTab = Tab.feed
        var user: User
        var selectedIndex = 0
        var feed: FeedViewReducer.State
        var search: SearchViewReducer.State
        var profile: ProfileViewReducer.State
        var reels: ReelsContainerReducer.State
        var notification: NotificationViewReducer.State
        
        init(authenticatedUser: User) {
            self.user = authenticatedUser
            self.feed = FeedViewReducer.State()
            self.search = SearchViewReducer.State()
            self.profile = ProfileViewReducer.State(user: authenticatedUser)
            self.reels = ReelsContainerReducer.State()
            self.notification = NotificationViewReducer.State()
        }
    }
    
    enum Action {
        case logoutButtonTapped
        case selectTab(Tab)
        case feed(FeedViewReducer.Action)
        case search(SearchViewReducer.Action)
        case profile(ProfileViewReducer.Action)
        case reels(ReelsContainerReducer.Action)
        case notification(NotificationViewReducer.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.feed, action: \.feed) {
            FeedViewReducer()
        }
        Scope(state: \.search, action: \.search) {
            SearchViewReducer()
        }
        Scope(state: \.profile, action: \.profile) {
            ProfileViewReducer()
        }
        Scope(state: \.reels, action: \.reels) {
            ReelsContainerReducer()
        }
        Scope(state: \.notification, action: \.notification) {
            NotificationViewReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .profile(.logoutButtonTapped):
                return .send(.logoutButtonTapped)
//            case .upload(.clearPostDataAndReturnToFeed):
//                return .send(.selectTab(.feed))
            case .reels:
                return .none
            case .logoutButtonTapped:
                return .none
            case let .selectTab(tab):
                state.currentTab = tab
                return .none
            case .feed:
                return .none
            case .search:
                return .none
            case .profile:
                return .none
            case .notification:
                return .none
            }
        }
    }
}

struct MainTabView: View {
    @Bindable var store: StoreOf<MainTableReducer>
    var body: some View {
        TabView(selection: $store.currentTab.sending(\.selectTab)) {
            FeedView(store: store.scope(state: \.feed, action: \.feed))
                .tabItem {
                    Image(systemName: "house")
                }.tag(MainTableReducer.Tab.feed)
             
            SearchView(store: store.scope(state: \.search, action: \.search))
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }.tag(MainTableReducer.Tab.search)
            
//            UploadPostView(store: store.scope(state: \.upload, action: \.upload))
//                .tabItem {
//                    Image(systemName: "plus.square")
//                }.tag(MainTableReducer.Tab.upload)
            
            ReelsContainerView(store: store.scope(state: \.reels, action: \.reels))
                .tabItem {
                    Image(systemName: "play.rectangle")
                }.tag(MainTableReducer.Tab.reels)
            
            NotificationView(store: store.scope(state: \.notification, action: \.notification))
                .tabItem {
                    Image(systemName: "heart")
                }.tag(MainTableReducer.Tab.notification)
            
            ProfileView(store: store.scope(state: \.profile, action: \.profile))
                .tabItem {
                    Image(systemName: "person")
                }.tag(MainTableReducer.Tab.profile)
        }
        .accentColor(.black)
    }
}

#Preview {
    MainTabView(store: Store(initialState: MainTableReducer.State(authenticatedUser: User.MOCK_USERS[0]),
                             reducer: { MainTableReducer() }))
}
