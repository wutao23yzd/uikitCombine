//
//  Post.swift
//  instagram_clone
//
//  Created by admin on 2025/6/19.
//

import Foundation

struct Comment: Equatable, Identifiable {
    let id: String
    var author: String
    var body: String
    var createAt: Date = .init()
}

struct Post: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    let caption: String
    var likes: Int
    let imageUrl: String
    var user: User?
}

extension Post {
    static var MOCK_POSTS: [Post] = [
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test one",
             likes: 25,
             imageUrl: "iron_man",
             user: User.MOCK_USERS[0]),
        
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test two",
             likes: 25,
             imageUrl: "mgdz",
             user: User.MOCK_USERS[1]),
        
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test three",
             likes: 35,
             imageUrl: "ls",
             user: User.MOCK_USERS[2]),
        
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test four",
             likes: 45,
             imageUrl: "iron_man",
             user: User.MOCK_USERS[3]),
        
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test five",
             likes: 215,
             imageUrl: "iron_man",
             user: User.MOCK_USERS[4]),
        
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test six",
             likes: 75,
             imageUrl: "hgf",
             user: User.MOCK_USERS[5]),
        
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test seven",
             likes: 259,
             imageUrl: "iron_man",
             user: User.MOCK_USERS[6]),
        
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test eight",
             likes: 415,
             imageUrl: "iron_man",
             user: User.MOCK_USERS[7]),
        
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test eight",
             likes: 415,
             imageUrl: "iron_man",
             user: User.MOCK_USERS[8]),
        
        Post(id: NSUUID().uuidString,
             ownerUid: NSUUID().uuidString,
             caption: "caption test nine",
             likes: 55,
             imageUrl: "iron_man",
             user: User.MOCK_USERS[9]),
    ]
}
