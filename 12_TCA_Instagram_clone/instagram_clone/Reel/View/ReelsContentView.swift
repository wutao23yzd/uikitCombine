//
//  ReelsContentView.swift
//  instagram_clone
//
//  Created by admin on 2025/7/7.
//

import SwiftUI
import AVKit
import ComposableArchitecture

@Reducer
struct ReelsContentReducer {
    
    @ObservableState
    struct State: Identifiable {
        var id: Video.ID
        var feed: Video
    }
    
    enum Action {
        case tapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .tapped:
                return .none
            }
        }
    }
}

struct ReelsContentView: View {
    
    @Bindable var store: StoreOf<ReelsContentReducer>
    
    @Binding var currentPlayingID: String?
    
    @State private var player: AVPlayer
    
    private var isActive: Bool { currentPlayingID == store.feed.id }
    
    init(store: StoreOf<ReelsContentReducer>, currentPlayingID: Binding<String?>) {
        self.store = store
        _currentPlayingID = currentPlayingID
        let url = Bundle.main.url(forResource: store.feed.videoUrl, withExtension: "mp4")!
        _player = State(initialValue: AVPlayer(url: url))
    }
    
    var body: some View {
        ZStack {
            LightweightVideoPlayer(player: player)
                .containerRelativeFrame([.horizontal, .vertical])
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.25), value: isActive)
            
            ReelsInfoView(feed: store.feed)
        }
        .onAppear { syncPlayback() }
        .onChange(of: currentPlayingID) { oldValue, newValue in
            syncPlayback()
        }
        .onDisappear {
            player.pause()
            player.seek(to: .zero)
        }
    }
    
    private func syncPlayback() {
        if currentPlayingID == store.feed.id {
            player.play()
        } else {
            player.pause()
        }
    }
}


final class PlayerLayerView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}

struct LightweightVideoPlayer: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerLayerView {
        let v = PlayerLayerView()
        v.backgroundColor = .black
        v.playerLayer.videoGravity = .resizeAspectFill
        v.playerLayer.player = player
        return v
    }
    func updateUIView(_ uiView: PlayerLayerView, context: Context) { }
}

//#Preview {
//    ReelsContentView()
//}
