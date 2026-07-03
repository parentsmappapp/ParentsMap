//
//  ProfileView.swift
//  ParentsMap
//
//  Created by Mariia on 27/6/2026.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogoutConfirmation = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            Color(.brandCream).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color(.brandPink))
                            .frame(width: 88, height: 88)
                            .overlay(
                                Text(initials)
                                    .font(.quicksand(.bold, size: 28))
                                    .foregroundColor(Color(.brandCoral))
                            )
                        
                        Text(authViewModel.currentUser?.fullName ?? "Parent")
                            .font(.quicksand(.bold, size: 20))
                            .foregroundColor(Color(.brandBrown))
                    }
                    .padding(.top, 48)
                    
                    VStack(spacing: 12) {
                        ProfileRow(icon: "pencil", title: "Edit Profile") {}
                        ProfileRow(icon: "bell.fill", title: "Notifications") {}
                        ProfileRow(icon: "questionmark.circle.fill", title: "Help & Support") {}
                    }
                    .padding(.horizontal, 24)
                    
                    VStack(spacing: 8) {
                        Button {
                            showLogoutConfirmation = true
                        } label: {
                            Text("Log Out")
                                .font(.quicksand(.semiBold, size: 15))
                                .foregroundColor(Color(.brandCoral))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.white)
                                .cornerRadius(26)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 26)
                                        .stroke(Color(.brandCoral), lineWidth: 1.5)
                                )
                        }
                        
                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Text("Delete Account")
                                .font(.quicksand(.medium, size: 13))
                                .foregroundColor(Color(.brandBrown).opacity(0.4))
                                .underline()
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 48)
                }
            }
        }
        .alert("Log out?", isPresented: $showLogoutConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                Task {
                    await authViewModel.logOut()
                }
            }
        } message: {
            Text("You can always log back in with your email and password.")
        }
        .alert("Delete your account?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    await authViewModel.deleteAccount()
                }
            }
        } message: {
            Text("This permanently deletes your account and saved places. This cannot be undone.")
        }
    }
    
    var initials: String {
        guard let name = authViewModel.currentUser?.fullName, !name.isEmpty else { return "P" }
        let parts = name.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(Color(.brandCoral))
                    .frame(width: 24)
                
                Text(title)
                    .font(.quicksand(.medium, size: 15))
                    .foregroundColor(Color(.brandBrown))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(.brandBrown).opacity(0.3))
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(Color.white)
            .cornerRadius(16)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
