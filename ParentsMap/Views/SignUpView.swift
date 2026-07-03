import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    enum Field: Hashable {
        case fullName, email, password, confirmPassword
    }
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordError = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear.frame(height: 64)
                    
                    Text("Create a free\naccount")
                        .font(.quicksand(.bold, size: 26))
                        .foregroundColor(Color(.brandBrown))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)

                    VStack(spacing: 16) {
                        PMFormField(
                            title: "Full Name",
                            placeholder: "Your name",
                            text: $fullName,
                            textContentType: .name,
                            isFocused: focusedField == .fullName,
                            onTap: { focusedField = .fullName }
                        )

                        PMFormField(
                            title: "Email",
                            placeholder: "your@email.com",
                            text: $email,
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            isFocused: focusedField == .email,
                            onTap: { focusedField = .email }
                        )

                        PMFormField(
                            title: "Password",
                            placeholder: "Min 6 characters",
                            text: $password,
                            isSecure: true,
                            textContentType: .newPassword,
                            isFocused: focusedField == .password,
                            showPassword: showPassword,
                            onTogglePassword: { showPassword.toggle() },
                            onTap: { focusedField = .password }
                        )

                        PMFormField(
                            title: "Confirm Password",
                            placeholder: "Repeat password",
                            text: $confirmPassword,
                            isSecure: true,
                            textContentType: .newPassword,
                            isFocused: focusedField == .confirmPassword,
                            showPassword: showConfirmPassword,
                            onTogglePassword: { showConfirmPassword.toggle() },
                            onTap: { focusedField = .confirmPassword }
                        )

                        if !passwordError.isEmpty {
                            Text(passwordError)
                                .font(.quicksand(.medium, size: 13))
                                .foregroundColor(Color(.brandCoral))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .font(.quicksand(.medium, size: 13))
                                .foregroundColor(Color(.brandCoral))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        PMPrimaryButton("Register", icon: "chevron.right", isLoading: authViewModel.isLoading) {
                            focusedField = nil
                            Task {
                                await signUp()
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 24)
                }
            }
            
            HStack(spacing: 16) {
                PMBackButton(action: { dismiss() })

                Text("Register")
                    .font(.quicksand(.bold, size: 22))
                    .foregroundColor(Color(.brandBrown))

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
            
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
        .alert("Account already exists", isPresented: $authViewModel.accountAlreadyExists) {
            Button("Log In") {
                dismiss()
            }
            Button("Dismiss", role: .cancel) {}
        } message: {
            Text("This account is connected to an existing Parents Map account. Do you want to sign in instead?")
        }
    }

    private func signUp() async {
        passwordError = ""

        guard !fullName.isEmpty else {
            passwordError = "Please enter your name"
            return
        }

        guard password == confirmPassword else {
            passwordError = "Passwords don't match"
            return
        }

        guard password.count >= 6 else {
            passwordError = "Password must be at least 6 characters"
            return
        }

        await authViewModel.signUp(
            email: email,
            password: password,
            fullName: fullName
        )

        if authViewModel.isLoggedIn {
            dismiss()
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
