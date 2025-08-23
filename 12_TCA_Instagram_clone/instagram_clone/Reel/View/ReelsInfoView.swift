//
//  ReelsInfoView.swift
//  instagram_clone
//
//  Created by admin on 2025/7/8.
//

import SwiftUI

struct ReelsInfoView: View {
    
    var feed: Video
    let safeInset = UIApplication.shared.safeAreaInset
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(feed.user.fullname)
                    
                    Text(feed.caption)
                }
                .foregroundStyle(.white)
                
                Spacer()
                
                VStack(spacing: 24) {
                    ZStack(alignment: .bottom) {
                        CircularProfileImageView(imageUrl: feed.user.profileImageUrl, dimension: 48)
                            .overlay(Circle().stroke(.white))
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.isLikedColor)
                            .background(.white)
                            .clipShape(Circle())
                            .offset(x:0, y: 6)
                    }
                    .padding(.bottom, 20)
                    
                    Button {
                        
                    }label: {
                        VStack (spacing:2){
                            TikTokIconView(icon: .heart, color: feed.isLiked ? Color.isLikedColor : .white)
                            Text(feed.likes)
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
                            Text(feed.comments)
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
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 10)
        .padding(.bottom, safeInset.bottom + 49)
    }
}
extension UIApplication {
    var safeAreaInset: UIEdgeInsets {
        let keyWindow = connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        return keyWindow?.safeAreaInsets ?? .zero
    }
}
extension Color {
    // Hex color initializer
    init(hex: String, opacity: Double = 1.0) {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
   
    static let isLikedColor = Color(hex: "#FD2A51")
    static let isSavedColor = Color(hex: "#FAD016")

}

//#Preview {
//    ReelsInfoView()
//}
