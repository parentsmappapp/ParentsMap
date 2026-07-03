//
//  StaggerReveal.swift
//  ParentsMap
//
//  Created by Mariia on 28/6/2026.
//

import SwiftUI

struct StaggerReveal: ViewModifier {
    let order: Int
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 16)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4).delay(Double(order) * 0.08)) {
                    isVisible = true
                }
            }
    }
}

extension View {
    func staggerReveal(_ order: Int) -> some View {
        modifier(StaggerReveal(order: order))
    }
}
