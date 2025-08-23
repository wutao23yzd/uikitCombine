//
//  Notification.swift
//  instagram_clone
//
//  Created by admin on 2025/6/25.
//

import Foundation


struct Notification: Identifiable {
    enum Kind {
        case liked
        case newFollower
        case suggestFollower
        case comment
    }
    
    let id: String
    let kind: Kind
    let users: [User]
    let post: Post
    let duration: String
    var comment: String?
    
    var userNames: String {
        return users.map { $0.username }.joined(separator: ", ")
    }
}

extension Notification {
    static var MOCK_Notification: [Notification] = [
      Notification(id: NSUUID().uuidString,
                   kind: .liked,
                   users: [User.MOCK_USERS[0]],
                   post: Post.MOCK_POSTS[0],
                   duration: "25分钟前"),
      Notification(id: NSUUID().uuidString,
                   kind: .newFollower,
                   users: [User.MOCK_USERS[1]],
                   post: Post.MOCK_POSTS[1],
                   duration: "1小时前"),
      Notification(id: NSUUID().uuidString,
                   kind: .liked,
                   users: [User.MOCK_USERS[2]],
                   post: Post.MOCK_POSTS[2],
                   duration: "2小时前"),
      Notification(id: NSUUID().uuidString,
                   kind: .comment,
                   users: [User.MOCK_USERS[3]],
                   post: Post.MOCK_POSTS[3],
                   duration: "3小时前",
                   comment: "你好，世界！这里是中国"),
      Notification(id: NSUUID().uuidString,
                   kind: .suggestFollower,
                   users: [User.MOCK_USERS[4]],
                   post: Post.MOCK_POSTS[4],
                   duration: "5小时前"),
      Notification(id: NSUUID().uuidString,
                   kind: .newFollower,
                   users: [User.MOCK_USERS[5]],
                   post: Post.MOCK_POSTS[5],
                   duration: "7小时前"),
      Notification(id: NSUUID().uuidString,
                   kind: .liked,
                   users: [User.MOCK_USERS[6]],
                   post: Post.MOCK_POSTS[6],
                   duration: "1天前"),
      Notification(id: NSUUID().uuidString,
                   kind: .comment,
                   users: [User.MOCK_USERS[7]],
                   post: Post.MOCK_POSTS[7],
                   duration: "1周前",
                   comment: "天干物燥，小心火烛"),
      Notification(id: NSUUID().uuidString,
                   kind: .suggestFollower,
                   users: [User.MOCK_USERS[1], User.MOCK_USERS[8]],
                   post: Post.MOCK_POSTS[8],
                   duration: "1个月前",
                   comment: "天干物燥，小心火烛"),
      Notification(id: NSUUID().uuidString,
                   kind: .newFollower,
                   users: [User.MOCK_USERS[1], User.MOCK_USERS[8]],
                   post: Post.MOCK_POSTS[9],
                   duration: "1年前"),
    ]
}
