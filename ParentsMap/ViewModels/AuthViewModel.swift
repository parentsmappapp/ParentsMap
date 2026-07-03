//
//  AuthViewModel.swift
//  ParentsMap
//
//  Created by Mariia on 10/6/2026.
//
import Foundation
import Supabase

@MainActor
class AuthViewModel: ObservableObject {
    @Published var accountAlreadyExists = false
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: UserProfile?
    
    init() {
        Task {
            await checkSession()
        }
    }
    
    // Check if user is already logged in
    func checkSession() async {
        do {
            let session = try await supabase.auth.session
            self.isLoggedIn = true
            await loadUserProfile(userId: session.user.id)
        } catch {
            self.isLoggedIn = false
        }
    }
    
    // Sign up with email and password
    func signUp(email: String, password: String, fullName: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await supabase.auth.signUp(
                email: email,
                password: password,
                data: ["full_name": .string(fullName)]
            )
            if let identities = response.user.identities, identities.isEmpty {
                // Email already registered and confirmed — Supabase hides this via empty identities
                self.accountAlreadyExists = true
            } else if response.session != nil {
                self.isLoggedIn = true
                await loadUserProfile(userId: response.user.id)
            } else {
                self.errorMessage = "Please check your email to confirm your account, then log in."
            }
        } catch {
            if error.localizedDescription.contains("already registered") || error.localizedDescription.contains("already exists") {
                self.accountAlreadyExists = true
            } else {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }
    // Log in with email and password
    func logIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            self.isLoggedIn = true
            await loadUserProfile(userId: session.user.id)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // Log out
    func logOut() async {
        do {
            try await supabase.auth.signOut()
            self.isLoggedIn = false
            self.currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Load user profile from Supabase
    func loadUserProfile(userId: UUID) async {
        do {
            let profile: UserProfile = try await supabase
                .from("users")
                .select()
                .eq("id", value: userId.uuidString)
                .single()
                .execute()
                .value
            self.currentUser = profile
            print("✅ Loaded profile for: \(profile.fullName ?? "no name")")
        } catch {
            print("❌ Could not load profile: \(error)")
        }
    }
    
    // Delete account
    func deleteAccount() async {
        do {
            guard let userId = currentUser?.id else { return }
            try await supabase
                .from("users")
                .delete()
                .eq("id", value: userId.uuidString)
                .execute()
            try await supabase.auth.signOut()
            self.isLoggedIn = false
            self.currentUser = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
