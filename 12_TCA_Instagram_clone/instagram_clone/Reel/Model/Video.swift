//
//  Untitled.swift
//  instagram_clone
//
//  Created by admin on 2025/7/6.
//


import Foundation
import AVFoundation

struct Video : Identifiable {
    var id = UUID().uuidString
    var videoUrl : String
    var likes: String
    var comments: String
    var caption: String
    var user: User
    var isLiked: Bool = false
    var isSaved: Bool = false
    var totalSaved: String = "234"
    var totalReposts: String = "48"
}

extension Video {
    static var MOCK_VIDEOS: [Video] = [
        Video(videoUrl: "reel_1",
              likes: "1M",
              comments: "22.7k",
              caption: "如果有人试图拉下美国国旗，当场开枪。",
              user: User.MOCK_USERS[0]),
        Video(videoUrl: "reel_2",
              likes: "297",
              comments: "4",
              caption: "格言是对一个重要而无可争议的真理的准确而崇高的表达。——健全的格言是善的萌芽；它们深深地印在记忆中，巩固和加强了意志",
              user: User.MOCK_USERS[1], isLiked: true),
        Video(videoUrl: "reel_3",
              likes: "2.7M",
              comments: "222.7k",
              caption: "人类；以及便携式管道的巧妙组装。",
              user: User.MOCK_USERS[2]),
        Video(videoUrl: "reel_4",
              likes: "25k",
              comments: "1.1k",
              caption: "昨晚狂风大作。一阵红色的云，坚硬的，紫色和黑色的水色物质，柔软如水冰，然后是坚硬的绿色石头、蓝色石头和一道深红色的涟漪。",
              user: User.MOCK_USERS[3]),
        Video(videoUrl: "reel_5",
              likes: "289",
              comments: "1",
              caption: "如果我说，在悲伤或骄傲中，我厌倦了诚实的事情，我撒谎了。",
              user:  User.MOCK_USERS[4]),
        Video(videoUrl: "reel_6",
              likes: "52M",
              comments: "1M",
              caption: "没有经济问题，从某种意义上说，从来没有",
              user: User.MOCK_USERS[5]),
        Video(videoUrl: "reel_7",
              likes: "17M",
              comments: "2k",
              caption: "毕竟，对整个人类来说，没有出口。我们不是从火星或月球获得外汇开始发展的。人类是一个封闭的社会。",
              user: User.MOCK_USERS[6]),
    ]
}
