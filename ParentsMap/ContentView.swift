//
//  ContentView.swift
//  ParentsMap
//
//  Created by Mariia on 30/5/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                OnboardingView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
