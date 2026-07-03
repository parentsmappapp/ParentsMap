import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    enum Field: Hashable {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showForgotPassword = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    if focusedField == nil {
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                            .padding(.top, 100)
                        
                        VStack(spacing: 8) {
                            Text("Welcome Back")
                                .font(.quicksand(.bold, size: 26))
                                .foregroundColor(Color(.brandBrown))
                            
                            Text("Login to access your account")
                                .font(.quicksand(.medium, size: 14))
                                .foregroundColor(Color(.brandBrown).opacity(0.6))
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                    } else {
                        Spacer()
                            .frame(height: 100)
                    }
                    
                    VStack(spacing: 16) {
                        
                        PMFormField(
                            title: "Your email",
                            placeholder: "Enter your email",
                            text: $email,
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            isFocused: focusedField == .email,
                            onTap: { focusedField = .email }
                        )
                        
                        PMFormField(
                            title: "Password",
                            placeholder: "Password",
                            text: $password,
                            isSecure: true,
                            textContentType: .password,
                            isFocused: focusedField == .password,
                            showPassword: showPassword,
                            onTogglePassword: { showPassword.toggle() },
                            onTap: { focusedField = .password }
                        )
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                showForgotPassword = true
                            } label: {
                                Text("Forgot lost password?")
                                    .font(.quicksand(.medium, size: 13))
                                    .foregroundColor(Color(.brandCoral))
                            }
                        }
                        
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .font(.quicksand(.medium, size: 13))
                                .foregroundColor(Color(.brandCoral))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        PMPrimaryButton(
                            "Log In",
                            icon: "chevron.right",
                            isLoading: authViewModel.isLoading
                        ) {
                            focusedField = nil
                            
                            Task {
                                await authViewModel.logIn(
                                    email: email,
                                    password: password
                                )
                                
                                if authViewModel.isLoggedIn {
                                    dismiss()
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        HStack {
                            Rectangle()
                                .fill(Color(.brandBrown).opacity(0.2))
                                .frame(height: 1)
                            
                            Text("or Sign In With")
                                .font(.quicksand(.medium, size: 12))
                                .foregroundColor(Color(.brandBrown).opacity(0.5))
                                .fixedSize()
                            
                            Rectangle()
                                .fill(Color(.brandBrown).opacity(0.2))
                                .frame(height: 1)
                        }
                        .padding(.top, 16)
                        
                        Button {
                            // Apple sign in — Phase 5
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 16))
                                
                                Text("Apple")
                                    .font(.quicksand(.semiBold, size: 15))
                            }
                            .foregroundColor(Color(.brandBrown))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                        }
                        
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .font(.quicksand(.regular, size: 13))
                                .foregroundColor(
                                    Color(.brandBrown).opacity(0.6)
                                )
                            
                            Button {
                                dismiss()
                            } label: {
                                Text("Sign up")
                                    .font(.quicksand(.bold, size: 13))
                                    .foregroundColor(Color(.brandCoral))
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 24)
                }
            }
            .overlay(alignment: .topLeading) {
                PMBackButton(action: { dismiss() })
                    .padding(.leading, 24)
                    .padding(.top, 48)
            }
            
            if focusedField != nil {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                        .font(.quicksand(.semiBold, size: 15))
                        .foregroundColor(Color(.brandCoral))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .overlay(Rectangle().frame(height: 0.5).foregroundColor(Color(.brandBrown).opacity(0.15)), alignment: .top)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .transition(.opacity)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .fullScreenCover(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
        .scrollDismissesKeyboard(.interactively)
        .animation(.easeOut(duration: 0.25), value: focusedField)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
