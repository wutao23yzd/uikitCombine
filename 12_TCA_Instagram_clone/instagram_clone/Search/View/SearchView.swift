//
//  SearchView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/18.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SearchViewReducer {
    
    @ObservableState
    struct State: Equatable {
        var searchText: String = ""
        var users:[User] = []
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case response(Result<[User], Never>)
        case onAppear
        
    }
    
    @Dependency(\.searchClient) var searchClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.searchText):
                return runSearch(text: state.searchText)
            case let .response(.success(users)):
                state.users = users
                return .none
            case .binding:
                return .none
            case .onAppear:
                return runSearch(text: state.searchText)
            default:
                return .none
            }
        }
    }
    
    func runSearch(text: String) -> Effect<Action> {
        return .run { send in
            do {
                let users = try await searchClient.search(text)
                await send(.response(.success(users)))
            } catch {
                await send(.response(.success([])))
            }
        }
    }
}

struct SearchView: View {
    @Bindable var store: StoreOf<SearchViewReducer>
    init(store: StoreOf<SearchViewReducer>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(store.users) { user in
                        HStack(spacing: 8) {
                            CircularProfileImageView(imageUrl: user.profileImageUrl, dimension: 40)
                            
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .fontWeight(.semibold)
                                Text(user.fullname)
                            }
                            .font(.footnote)
                              
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
                .searchable(text: $store.searchText, prompt: "搜索...")
            }
            .task {
               await store.send(.onAppear).finish()
            }
            .navigationTitle("搜索")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SearchView(store: Store(initialState: SearchViewReducer.State(), reducer: {
        SearchViewReducer()
    }))
}
