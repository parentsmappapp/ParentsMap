//
//  PMBackButton.swift
//  ParentsMap
//
//  Created by Mariia on 17/6/2026.
//


import SwiftUI

struct PMBackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color(red: 0.196, green: 0.098, blue: 0.086).opacity(0.10), radius: 10, x: 0, y: 4)
                
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(.brandCoral))
            }
        }
    }
}
