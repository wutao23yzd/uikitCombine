//
//  PostGridView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/24.
//

import SwiftUI

struct PostGridView: View {
    private let gridItem: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width/3) - 1
    
    var body: some View {
        LazyVGrid(columns: gridItem, spacing: 1) {
            ForEach(0..<4) { idx in
                Image("iron_man")
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageDimension, height: imageDimension)
                    .clipped()
            }
        }
    }
}

#Preview {
    PostGridView()
}
