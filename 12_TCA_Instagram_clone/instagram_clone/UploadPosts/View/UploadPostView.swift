//
//  UploadPostView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/18.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI

@Reducer
struct UploadPostReducer {
    
    @ObservableState
    struct State: Equatable {
        var caption = ""
        var imagePickerPresented = false
        var postImage: Image?
        var selectedImage: PhotosPickerItem?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loadImageResponse(Result<Image, ImageLoadingError>)
        case onAppear
        case clearPostDataAndReturnToFeed
    }
    
    enum ImageLoadingError: Error, Equatable { case failed }
    
    enum CancelID { case loadImage }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.imagePickerPresented.toggle()
                return .none
            case .binding(\.selectedImage):
                guard let item = state.selectedImage else {
                    state.postImage = nil
                    return .cancel(id: CancelID.loadImage)
                }
                return .run { send in
                    do {
                        guard let data = try await item.loadTransferable(type: Data.self),
                              let uiImage = UIImage(data: data) else {
                            throw ImageLoadingError.failed
                        }
                        
                        await send(.loadImageResponse(.success(Image(uiImage: uiImage))))
                    } catch {
                        await send(.loadImageResponse(.failure(.failed)))
                    }
                }
                .cancellable(id: CancelID.loadImage, cancelInFlight: true)
            case let .loadImageResponse(.success(image)):
                state.postImage = image
                return .none
            case .loadImageResponse(.failure):
                state.postImage = nil
                return .none
            case .clearPostDataAndReturnToFeed:
                state.caption = ""
                state.selectedImage = nil
                state.postImage = nil
                return .none
            case .binding:
                return .none
            }
        }
    }
}

struct UploadPostView: View {
    @Bindable var store: StoreOf<UploadPostReducer>
    init(store: StoreOf<UploadPostReducer>) {
        self.store = store
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    store.send(.clearPostDataAndReturnToFeed)
                } label: {
                    Text("退出")
                }
                
                Spacer()
                
                Text("新内容")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    store.send(.clearPostDataAndReturnToFeed)
                } label: {
                    Text("上传")
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            HStack(spacing: 8) {
                if let image = store.postImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                }
                
                TextField("输入说明...", text: $store.caption, axis: .vertical)
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            store.send(.onAppear)
        }
        .photosPicker(isPresented: $store.imagePickerPresented, selection: $store.selectedImage)
        .toolbar(.hidden, for: .tabBar)
       
    }
}

#Preview {
    UploadPostView(store: Store(initialState: UploadPostReducer.State(), reducer: {
        UploadPostReducer()
    }))
}
