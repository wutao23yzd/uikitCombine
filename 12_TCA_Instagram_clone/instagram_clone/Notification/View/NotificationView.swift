//
//  NotificationView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct NotificationViewReducer {
    
    @ObservableState
    struct State {
        var notifications: [Notification] = []
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case response(Result<[Notification], Error>)
    }
    
    @Dependency(\.notificationClient) var notificationClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        let notis =  try await notificationClient.fetch()
                        await send(.response(.success(notis)))
                    } catch {
                        await send(.response(.failure(error)))
                    }
                }
            case let .response(.success(notis)):
                state.notifications = notis
                return .none
            case .binding:
                return .none
            default:
                return .none
            }
        }
    }
    
     
}

struct NotificationView: View {
    @Bindable var store: StoreOf<NotificationViewReducer>
    init(store: StoreOf<NotificationViewReducer>) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(store.notifications) { item in
                    NotificationItem(item: item)
                }
            }
            .task {
               await store.send(.onAppear).finish()
            }
            .navigationTitle("通知")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NotificationView(store: Store(initialState: NotificationViewReducer.State(), reducer: {
        NotificationViewReducer()
    }))
}
