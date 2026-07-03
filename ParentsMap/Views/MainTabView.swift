import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var savedPlacesService = SavedPlacesService()
    
    var body: some View {
        TabView {
            MapView()
                .environmentObject(authViewModel)
                .environmentObject(savedPlacesService)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Home")
                }
            
            SavedPlacesView()
                .environmentObject(authViewModel)
                .environmentObject(savedPlacesService)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Saved")
                }
            
            SubmitPlaceView()
                .environmentObject(authViewModel)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
            
            ProfileView()
                .environmentObject(authViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(Color(.brandCoral))
        .onReceive(authViewModel.$currentUser) { user in
            if let userId = user?.id {
                Task {
                    await savedPlacesService.loadSavedPlaceIds(userId: userId)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
