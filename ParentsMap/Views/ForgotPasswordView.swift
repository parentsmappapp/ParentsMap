//
//  ForgotPasswordView.swift
//  ParentsMap
//
//  Created by Mariia on 17/6/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var emailSent = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 16) {
                    PMBackButton(action: { dismiss() })
                    
                    Text("Forgot password?")
                        .font(.quicksand(.semiBold, size: 16))
                        .foregroundColor(Color(.brandBrown).opacity(0.7))
                    
                    Spacer()
                }
                .padding(.top, 60)
                
                if emailSent {
                    // Success state
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Reset link sent!")
                            .font(.quicksand(.bold, size: 28))
                            .foregroundColor(Color(.brandBrown))
                        
                        Text("We've sent an email to the address provided. Can't find it? Check your spam folder.")
                            .font(.quicksand(.medium, size: 15))
                            .foregroundColor(Color(.brandBrown).opacity(0.7))
                        
                        Image(systemName: "envelope.badge.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(.brandCoral))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                        
                        PMPrimaryButton("Back to Login") {
                            dismiss()
                        }
                    }
                } else {
                    // Request state
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Reset your\npassword now")
                            .font(.quicksand(.bold, size: 28))
                            .foregroundColor(Color(.brandBrown))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Your email")
                                .font(.quicksand(.semiBold, size: 13))
                                .foregroundColor(Color(.brandBrown))
                            TextField("Enter your email", text: $email)
                                .font(.quicksand(.regular, size: 15))
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(.horizontal, 16)
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(25)
                        }
                        
                        if let error = errorMessage {
                            Text(error)
                                .font(.quicksand(.medium, size: 13))
                                .foregroundColor(.red)
                        }
                        
                        PMPrimaryButton("Send me a new password", isLoading: isLoading) {
                            Task {
                                await sendResetEmail()
                            }
                        }
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Back to sign in page")
                                .font(.quicksand(.medium, size: 13))
                                .foregroundColor(Color(.brandCoral))
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 8)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
    
    func sendResetEmail() async {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            try await supabase.auth.resetPasswordForEmail(email)
            emailSent = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    ForgotPasswordView()
}
