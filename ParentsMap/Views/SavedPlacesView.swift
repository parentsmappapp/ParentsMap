//
//  SavedPlacesView.swift
//  ParentsMap
//
//  Created by Mariia on 28/6/2026.
//

import SwiftUI

struct SavedPlacesView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var savedPlacesService: SavedPlacesService
    @StateObject private var mapService = MapService()
    @State private var selectedPlace: PlaceWithDetails?
    
    var savedPlaces: [PlaceWithDetails] {
        mapService.places.filter { savedPlacesService.savedPlaceIds.contains($0.place.id) }
    }
    
    var body: some View {
        ZStack {
            Color(.brandCream).ignoresSafeArea()
            
            if savedPlaces.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 48))
                        .foregroundColor(Color(.brandBrown).opacity(0.3))
                    
                    Text("No saved places yet")
                        .font(.quicksand(.bold, size: 18))
                        .foregroundColor(Color(.brandBrown))
                    
                    Text("Tap the heart on any place to save it here")
                        .font(.quicksand(.medium, size: 14))
                        .foregroundColor(Color(.brandBrown).opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 48)
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Saved Places")
                            .font(.quicksand(.bold, size: 24))
                            .foregroundColor(Color(.brandBrown))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 56)
                        
                        VStack(spacing: 12) {
                            ForEach(savedPlaces) { place in
                                Button {
                                    selectedPlace = place
                                } label: {
                                    SavedPlaceRow(
                                        place: place,
                                        onUnsave: {
                                            if let userId = authViewModel.currentUser?.id {
                                                Task {
                                                    await savedPlacesService.toggleSave(placeId: place.place.id, userId: userId)
                                                }
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .task {
            await mapService.loadMapData()
        }
        .fullScreenCover(item: $selectedPlace) { place in
            PlaceDetailView(place: place)
                .environmentObject(authViewModel)
                .environmentObject(savedPlacesService)
        }
    }
}

struct SavedPlaceRow: View {
    let place: PlaceWithDetails
    let onUnsave: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.brandPink))
                .frame(width: 64, height: 64)
                .overlay(
                    Image(systemName: place.category?.icon ?? "mappin")
                        .font(.system(size: 22))
                        .foregroundColor(Color(.brandCoral))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(place.place.name)
                    .font(.quicksand(.bold, size: 15))
                    .foregroundColor(Color(.brandBrown))
                    .lineLimit(1)
                
                if let address = place.place.address {
                    Text(address)
                        .font(.quicksand(.medium, size: 12))
                        .foregroundColor(Color(.brandBrown).opacity(0.5))
                        .lineLimit(1)
                }
                
                HStack(spacing: 4) {
                    ForEach(0..<5) { i in
                        Image(systemName: i < Int(place.place.averageRating ?? 0) ? "star.fill" : "star")
                            .font(.system(size: 9))
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            Spacer()
            
            Button(action: onUnsave) {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color(.brandCoral))
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color(red: 0.416, green: 0.569, blue: 0.624).opacity(0.16), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    SavedPlacesView()
        .environmentObject(AuthViewModel())
        .environmentObject(SavedPlacesService())
}
