//
//  TikTokView.swift
//  Youtube_Tiktok
//
//  Created by Sopheamen VAN on 11/10/24.
//

import SwiftUI
import AVKit

struct TikTokView: View {
   
    var feedData: [FeedResponse] = feedForYouData
    
    @State private var scrollPosition: String?
    
    @State private var currentPlayingID: String?
    
    var body: some View {
        
        NavigationStack {
            ZStack (alignment: .top){
              
                ScrollView (showsIndicators: false){
                    LazyVStack (spacing:0){
                        ForEach(feedData) { feed in
                            TikTokContentView(feed: feed,
                                              currentPlayingID: $currentPlayingID)
                                .id(feed.id)
                                .onAppear {
                                
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .onAppear {
                    currentPlayingID = feedData.first?.id
                }
                .scrollPosition(id: $scrollPosition)
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
                .onChange(of: scrollPosition) { feedId, newValue in
                  
                    currentPlayingID = newValue
                }
                
                // tab and search view
                TabViewAndSearchView()
            }
           
        }
    }
}

#Preview {
    TikTokView()
}

struct TabViewAndSearchView:View {
    var body: some View {
        HStack {
            Spacer()
            HStack (alignment: .top, spacing: 20){
                Text("Following")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.7))
                
                VStack (spacing: 6){
                    Text("For You")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Rectangle()
                        .fill(.white)
                        .frame(width: 30)
                        .frame(height: 2)
                }
            }
            Spacer()
            // search
            Button {
                
            }label: {
                TikTokIconView(icon: .search, size:24, color: .white)
            }
        }
        .padding(.horizontal)
    }
}
