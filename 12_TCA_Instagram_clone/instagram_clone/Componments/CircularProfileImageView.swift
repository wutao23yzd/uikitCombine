//
//  CircularProfileImageView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/22.
//

import SwiftUI

struct CircularProfileImageView: View {
    let imageUrl: String?
    let dimension: CGFloat
    var body: some View {
        if let imageUrl = imageUrl {
            Image(imageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: dimension, height: dimension)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: dimension,height: dimension)
                .clipShape(Circle())
                .foregroundStyle(Color(.systemGray4))
        }
    }
}

#Preview {
    CircularProfileImageView(imageUrl: nil, dimension: 40)
}
