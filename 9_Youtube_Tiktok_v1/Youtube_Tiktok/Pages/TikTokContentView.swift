//
//  TikTokContentView.swift
//  Youtube_Tiktok
//
//  Created by Sopheamen VAN on 11/10/24.
//

import SwiftUI
import Kingfisher
import AVKit

struct TikTokContentView: View {
    var feed: FeedResponse
  

    @Binding var currentPlayingID: String?
    
    @State private var player: AVPlayer
    
    private var isActive: Bool { currentPlayingID == feed.id }
    
    init(feed: FeedResponse,
         currentPlayingID: Binding<String?>) {
        self.feed = feed
        _currentPlayingID = currentPlayingID               // 绑定
        // 为当前视频创建独立 AVPlayer
        let url = Bundle.main.url(forResource: feed.videoUrl,
                                  withExtension: "mp4")!
        _player = State(initialValue: AVPlayer(url: url))
    }
    
    var body: some View {
        ZStack {
            LightweightVideoPlayer(player: player)
            .containerRelativeFrame([.horizontal,.vertical])
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.25), value: isActive)
  
            ContentInfoView(feed: feed)
        }
        .onAppear { syncPlayback() }                // 首次出现
        .onChange(of: currentPlayingID) { _ in
            syncPlayback()                          // 滚动时更新
        }
        .onDisappear {                              // 离屏时暂停
            player.pause()
            player.seek(to: .zero)
        }
    }
    
    private func syncPlayback() {
        if currentPlayingID == feed.id {
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


struct ContentInfoView:View {
    var feed: FeedResponse
    var body: some View {
        VStack {
          
            Spacer()
            
          
            HStack (alignment: .bottom){
       
                VStack(alignment: .leading, spacing: 4){
                    Text(feed.fullName)
                        .font(.headline)
                       
                    Text(feed.caption)
                        .font(.subheadline)
                        
                }
               
                .foregroundStyle(.white)
                
                Spacer()
                
           
                VStack (spacing: 24){
                    // profile with plus icon
                    ZStack (alignment: .bottom){
                     
                        KFImage(URL(string: feed.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.white))
                    
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.isLikedColor)
                            .background(.white)
                            .clipShape(Circle())
                            .offset(x: 0, y: 6)
                    }
                    .padding(.bottom, 20)
                    
                    
                    // like button
                    Button {
                        
                    }label: {
                        VStack (spacing:2){
                            TikTokIconView(icon: .heart, color: feed.isLiked ? Color.isLikedColor : .white)
                            Text(feed.totalLikes)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                    // comment button
                    Button {
                        
                    }label: {
                        VStack (spacing:2){
                            TikTokIconView(icon: .comment, color: .white)
                            Text(feed.totalComments)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                    // saved button
                    Button {
                        
                    }label: {
                        VStack (spacing:2){
                            TikTokIconView(icon: .saved, size: 26,color: feed.isSaved ? Color.isSavedColor :  .white)
                            Text(feed.totalSaved)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                    // repost button
                    Button {
                        
                    }label: {
                        VStack (spacing:2){
                            TikTokIconView(icon: .repost,size: 26 ,color: .white)
                            Text(feed.totalReposts)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
               
                    KFImage(URL(string: feed.musicCoverUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}
