//
//  PMFormField.swift
//  ParentsMap
//
//  Created by Mariia on 23/6/2026.
//

import SwiftUI

struct PMFormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var isFocused: Bool
    var showPassword: Bool = false
    var onTogglePassword: (() -> Void)? = nil
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.quicksand(.semiBold, size: 13))
                .foregroundColor(Color(.brandBrown))
            
            HStack {
                Group {
                    if isSecure && !showPassword {
                        SecureField(placeholder, text: $text)
                            .submitLabel(.done)
                    } else {
                        TextField(placeholder, text: $text)
                            .submitLabel(.done)
                    }
                }
                .font(.quicksand(.regular, size: 15))
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .textContentType(textContentType)
                
                if isSecure {
                    Button {
                        onTogglePassword?()
                    } label: {
                        Text(showPassword ? "Hide" : "Show")
                            .font(.quicksand(.semiBold, size: 13))
                            .foregroundColor(Color(.brandBrown).opacity(0.6))
                            .underline()
                    }
                } else if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(.brandBrown).opacity(0.3))
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .focusableField(isFocused: isFocused)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

struct FocusableField: ViewModifier {
    let isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(28)
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color(.brandCoral), lineWidth: isFocused ? 2 : 0)
            )
            .shadow(
                color: isFocused
                    ? Color(.brandCoral).opacity(0.25)
                    : Color(red: 0.416, green: 0.569, blue: 0.624).opacity(0.16),
                radius: isFocused ? 10 : 8,
                x: 0,
                y: 4
            )
            .scaleEffect(isFocused ? 1.01 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
}

extension View {
    func focusableField(isFocused: Bool) -> some View {
        modifier(FocusableField(isFocused: isFocused))
    }
}
