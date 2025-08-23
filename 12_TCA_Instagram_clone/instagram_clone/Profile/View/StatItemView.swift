//
//  StatItemView.swift
//  instagram_clone
//
//  Created by admin on 2025/6/24.
//

import SwiftUI

struct StatItemView: View {
    
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.footnote)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(width: 76)
    }
}

#Preview {
    StatItemView(title: "收藏", value: "3")
}
