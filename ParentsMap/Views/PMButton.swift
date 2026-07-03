//
//  PMButton.swift
//  ParentsMap
//
//  Created by Mariia on 13/6/2026.
//

import SwiftUI

struct PMPrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isLoading: Bool = false
    
    init(_ title: String, icon: String? = nil, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Bottom shadow layer — gives candy depth
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.brandCoral).opacity(0.5))
                    .offset(y: 6)
                    .blur(radius: 3)
                
                // Main button
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(.brandCoral).opacity(0.85),
                                Color(.brandCoral)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.15), Color.clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.quicksand(.bold, size: 16))
                            .foregroundColor(.white)
                        if let icon = icon {
                            Image(systemName: icon)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .frame(height: 54)
        }
        .buttonStyle(CandyButtonStyle())
    }
}

struct PMSecondaryButton: View {
    let title: String
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Bottom shadow layer
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.brandCoral).opacity(0.2))
                    .offset(y: 4)
                    .blur(radius: 1)
                
                // Main button
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color(.brandCoral), lineWidth: 2)
                    )
                
                Text(title)
                    .font(.quicksand(.bold, size: 16))
                    .foregroundColor(Color(.brandCoral))
            }
            .frame(height: 54)
        }
        .buttonStyle(CandyButtonStyle())
    }
}

// Makes the button press down when tapped
struct CandyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        PMPrimaryButton("How it Works", icon: "chevron.right") {}
        PMSecondaryButton("Skip Tutorial") {}
    }
    .padding()
}
