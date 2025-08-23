//
//  NotificationItem.swift
//  instagram_clone
//
//  Created by admin on 2025/6/25.
//

import SwiftUI

struct NotificationItem: View {
    
    let item: Notification
    
    var body: some View {
        HStack {
            CircularProfileImageView(imageUrl: item.users.first?.profileImageUrl, dimension: 40)
          
            if item.kind == .liked {
                Text(item.userNames)
                    .font(.caption)
                    .fontWeight(.semibold) +
                Text(item.users.count == 1 ? "喜欢你的帖子" : "和更多人喜欢你的帖子")
                    .font(.caption)
                    .fontWeight(.medium) +
                Text(item.duration)
                    .font(.caption2)
                    .fontWeight(.light)
            } else if item.kind == .comment {
                Text(makeAttr(item: item))
                    
            } else if item.kind == .suggestFollower {
                Text(item.userNames)
                    .font(.caption)
                    .fontWeight(.semibold) +
                Text(" 你可以能认识的人。")
                    .font(.caption)
                    .fontWeight(.medium) +
                Text(item.duration)
                    .font(.caption2)
                    .fontWeight(.light)
            } else if item.kind == .newFollower {
                Text(item.userNames)
                    .font(.caption)
                    .fontWeight(.semibold) +
                Text(" 开始关注你。")
                    .font(.caption)
                    .fontWeight(.medium) +
                Text(item.duration)
                    .font(.caption2)
                    .fontWeight(.light)
            }
            
            Spacer()
            
            if item.kind == .suggestFollower {
                Button {
                    
                } label: {
                    Text("关注")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 100, height: 30)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            } else if item.kind == .newFollower {
                Button {
                    
                } label: {
                    Text("被关注")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                        .frame(width: 100, height: 30, alignment: .center)
                        .overlay {RoundedRectangle(cornerRadius: 6).stroke(.gray, lineWidth: 1)
                        }
                        
                }
                
            } else {
                Image(item.post.imageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .clipped()
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .frame(width: UIScreen.main.bounds.size.width, alignment: .leading)
    }
    
    // 新增一个小函数，负责拼出彩色 / 加粗的 attributed 文本
    fileprivate func makeAttr(item: Notification) -> AttributedString {
        var s = AttributedString()

        func append(_ str: String, font: Font, weight: Font.Weight = .regular) {
            var piece = AttributedString(str)
            piece.font = font.weight(weight)
            s += piece
        }

        append(item.userNames, font: .caption, weight: .semibold)

        switch item.kind {
        case .liked:
            append(item.users.count == 1 ? " 喜欢你的帖子 " : " 和更多人喜欢你的帖子 ",
                   font: .caption)
        case .comment:
            append(" 在评论中提及了你：", font: .caption)
            append(item.comment ?? "", font: .caption, weight: .semibold)
            append(" ", font: .caption)
        case .suggestFollower:
            append(" 你可能认识的人。", font: .caption)
        case .newFollower:
            append(" 开始关注你。", font: .caption)
        }

        append(item.duration, font: .caption2)
        return s
    }

    
}

#Preview {
    NotificationItem(item: Notification.MOCK_Notification[3])
}
