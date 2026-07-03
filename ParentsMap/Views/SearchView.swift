//
//  SearchView.swift
//  ParentsMap
//
//  Created by Mariia on 1/7/2026.
//

import SwiftUI

struct SearchView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    let places: [PlaceWithDetails]
    let onSelectPlace: (PlaceWithDetails) -> Void
    
    let recentAreas = [
        "Randwick",
        "Maroubra",
        "Coogee",
        "Tamarama"
    ]
    
    var filteredPlaces: [PlaceWithDetails] {

        guard !searchText.isEmpty else {
            return []
        }

        return places.filter { place in

            place.place.name.localizedCaseInsensitiveContains(searchText)

            ||

            (place.place.address ?? "")
                .localizedCaseInsensitiveContains(searchText)

            ||

            (place.category?.name ?? "")
                .localizedCaseInsensitiveContains(searchText)

            ||

            place.tags.contains {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    struct NearbyArea: Identifiable {
        let id = UUID()
        let name: String
        let placeCount: Int
    }

    
    var body: some View {

            VStack(spacing: 0) {
                // MARK: Header
                HStack(spacing: 14) {

                    Button {
                        dismiss()
                    } label: {

                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(.brandCoral))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(
                                color: Color.black.opacity(0.06),
                                radius: 10,
                                y: 4
                            )
                    }

                    Text("Location")
                        .font(.quicksand(.bold, size: 24))
                        .foregroundColor(Color(.brandBrown))

                    Spacer()
                }
                .padding(.horizontal,20)
                .padding(.top,16)
                // MARK: Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(.brandBrown).opacity(0.45))

                    TextField("", text: $searchText, prompt:
                        Text("Search for suburb or amenity")
                            .font(.quicksand(.medium, size: 15))
                            .foregroundColor(Color(.brandBrown).opacity(0.45))
                    )
                    .font(.quicksand(.semiBold, size: 16))
                }
                .padding(.horizontal,16)
                .frame(height:52)
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.white.opacity(0.35))
                )
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(.horizontal, 20)
                .padding(.top, 20)
                if !isSearching {
                    // MARK: Current location
                    Button {
                    } label: {
                        
                        HStack(spacing:8){
                            Image(systemName:"location")
                            Text("Use my current location")
                                .font(.quicksand(.semiBold,size:14))
                        }
                        .foregroundColor(Color(.brandCoral))
                        .padding(.horizontal,18)
                        .frame(height:42)
                        .overlay(
                            Capsule()
                                .stroke(Color(.brandCoral),lineWidth:1.5)
                        )
                    }
                    .padding(.top,18)
                    // MARK: Recent
                    VStack(alignment:.leading,spacing:0){
                        Text("Explore nearby areas")
                            .font(.quicksand(.bold,size:16))
                            .foregroundColor(Color(.brandBrown))
                            .padding(.bottom,12)
                        ForEach(recentAreas,id:\.self){ area in
                            Button {
                            } label: {
                                
                                HStack(alignment:.top,spacing:12){
                                    
                                    Image(systemName:"mappin.and.ellipse")
                                        .foregroundColor(Color(.brandBrown).opacity(0.55))
                                        .padding(.top,2)
                                    
                                    VStack(alignment:.leading,spacing:2){
                                        
                                        Text(area)
                                            .font(.quicksand(.semiBold,size:15))
                                            .foregroundColor(Color(.brandBrown))
                                        
                                        Text("New South Wales, Australia")
                                            .font(.quicksand(.medium,size:12))
                                            .foregroundColor(Color(.brandBrown).opacity(0.45))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.vertical,14)
                            }
                            Divider()
                        }
                    }
                    .padding(.horizontal,20)
                    .padding(.top,28)
                }
                if isSearching {
                    
                    if filteredPlaces.isEmpty {
                        Spacer()
                        VStack(spacing: 16) {

                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(Color(.brandBrown).opacity(0.3))

                            Text("No places found")
                                .font(.quicksand(.bold, size: 18))
                                .foregroundColor(Color(.brandBrown))

                            Text("Try searching for another suburb or amenity.")
                                .font(.quicksand(.medium, size: 14))
                                .foregroundColor(Color(.brandBrown).opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    } else {
                        
                        ScrollView {

                            LazyVStack(spacing: 0) {

                                ForEach(filteredPlaces) { place in

                                    Button {

                                        onSelectPlace(place)

                                        dismiss()

                                    } label: {
                                        SearchResultRow(place: place)
                                       }
                                    Divider()
                                        .padding(.leading, 62)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
    }
}
