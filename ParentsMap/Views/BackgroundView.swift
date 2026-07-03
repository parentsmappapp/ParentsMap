//
//  BackgroundView.swift
//  ParentsMap
//
//  Created by Mariia on 13/6/2026.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            // Base cream background
            Color(.brandCream)
                .ignoresSafeArea()
            
            // Tall narrow oval — matches Figma
            Ellipse()
                .fill(Color(.brandCreamBright))
                .frame(width: 399, height: 888)
                .offset(x: -133, y: -8)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    BackgroundView()
}
