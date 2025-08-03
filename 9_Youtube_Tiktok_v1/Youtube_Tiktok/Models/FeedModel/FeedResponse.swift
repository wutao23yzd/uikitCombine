//
//  FeedResponse.swift
//  Youtube_Tiktok
//
//  Created by Sopheamen VAN on 11/10/24.
//

import Foundation

struct FeedResponse: Identifiable {
    var id: String
    var fullName: String
    var imageUrl: String
    var caption: String
    var isLiked: Bool
    var isSaved: Bool
    var totalLikes: String
    var totalComments: String
    var totalSaved: String
    var totalReposts: String
    var musicCoverUrl: String
    var videoUrl: String
}
