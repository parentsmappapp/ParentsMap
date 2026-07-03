//
//  MapView.swift
//  ParentsMap
//
//  Created by Mariia on 19/6/2026.
//

import SwiftUI
import MapKit

enum SortOption: String {
    case none = "Default"
    case nearest = "Nearest first"
    case highestRated = "Highest rated"
    case mostReviewed = "Most reviewed"
}

struct MapView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var savedPlacesService: SavedPlacesService
    @StateObject private var mapService = MapService()
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.8915, longitude: 151.2025),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    @State private var hasCenteredOnUser = false
    @State private var selectedPlace: PlaceWithDetails?
    @State private var showPlaceDetail = false
    @State private var searchText = ""
    @State private var savedOnlySelected = false
    @State private var openNowSelected = false
    @State private var showTypeFilter = false
    @State private var selectedCategoryIds: Set<Int> = []
    @State private var showDistanceFilter = false
    @State private var selectedRadiusKm: Double? = nil
    @State private var showSortFilter = false
    @State private var selectedSort: SortOption = .none
    @State private var showSearch = false
    
    var placesWithDistance: [(place: PlaceWithDetails, distanceKm: Double?)] {
        mapService.places.map { place in
            (place: place, distanceKm: mapService.distance(from: locationManager.userLocation, to: place.place))
        }
    }
    
    var filteredPlaces: [(place: PlaceWithDetails, distanceKm: Double?)] {
        let filtered = placesWithDistance.filter { item in
            if openNowSelected && !mapService.isOpenNow(item.place.place) {
                return false
            }
            if !selectedCategoryIds.isEmpty {
                guard let categoryId = item.place.place.categoryId,
                      selectedCategoryIds.contains(categoryId) else {
                    return false
                }
            }
            if let radius = selectedRadiusKm {
                guard let distance = item.distanceKm, distance <= radius else {
                    return false
                }
            }
            if savedOnlySelected && !savedPlacesService.isSaved(item.place.place.id) {
                return false
            }
            return true
        }
        
        switch selectedSort {
        case .nearest:
            return filtered.sorted { ($0.distanceKm ?? .infinity) < ($1.distanceKm ?? .infinity) }
        case .highestRated:
            return filtered.sorted { ($0.place.place.averageRating ?? 0) > ($1.place.place.averageRating ?? 0) }
        case .mostReviewed:
            return filtered.sorted { ($0.place.place.reviewCount ?? 0) > ($1.place.place.reviewCount ?? 0) }
        case .none:
            return filtered
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $cameraPosition, selection: $selectedPlace) {
                ForEach(filteredPlaces, id: \.place.id) { item in
                    Marker(
                        item.place.place.name,
                        systemImage: item.place.category?.icon ?? "mappin",
                        coordinate: CLLocationCoordinate2D(
                            latitude: item.place.place.latitude,
                            longitude: item.place.place.longitude
                        )
                    )
                    .tag(item.place)
                    .tint(Color(.brandCoral))
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea(edges: .top)
            .overlay(alignment: .topTrailing) {
                Button {
                    if let location = locationManager.userLocation {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            cameraPosition = .region(
                                MKCoordinateRegion(
                                    center: location,
                                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                )
                            )
                        }
                    }
                } label: {
                    Image(systemName: "location.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(.brandBrown))
                        .frame(width: 60, height: 60)
                        .background(Color.white.opacity(0.8))
                        .background { Circle().fill(.ultraThinMaterial) }
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                        )
                        .shadow(color: Color(red: 0.196, green: 0.098, blue: 0.086).opacity(0.10), radius: 10, x: 0, y: 10)
                }
                .padding(.top, 180)
                .padding(.trailing, 16)
            }
            .onReceive(locationManager.$userLocation) { location in
                guard let location, !hasCenteredOnUser else { return }
                hasCenteredOnUser = true
                withAnimation(.easeInOut(duration: 0.45)) {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: location,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    )
                }
            }
            
            // MARK: - Search bar + Filters
            VStack(spacing: 12) {
                ZStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(.brandBrown).opacity(0.65))
                        
                        Text("Search amenity or suburb")
                            .font(.quicksand(.semiBold, size: 16))
                            .foregroundColor(Color(.brandBrown).opacity(0.55))

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .background(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.45))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                Color.white.opacity(0.75),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: Color(red: 0.196, green: 0.098, blue: 0.086).opacity(0.10),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                    .padding(.horizontal, 16)
                    .onTapGesture {
                       showSearch = true
                    }
                }
               
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterPill(title: "Open Now", icon: nil, isSelected: openNowSelected) {
                            openNowSelected.toggle()
                        }
                        FilterPill(title: "Type", icon: "chevron.down", isSelected: !selectedCategoryIds.isEmpty) {
                            showTypeFilter = true
                        }
                        FilterPill(title: "Distance", icon: "chevron.down", isSelected: selectedRadiusKm != nil) {
                            showDistanceFilter = true
                        }
                        FilterPill(title: "Sort", icon: "chevron.down", isSelected: selectedSort != .none) {
                            showSortFilter = true
                        }
                        FilterPill(title: "Saved", icon: "heart.fill", isSelected: savedOnlySelected) {
                            savedOnlySelected.toggle()
                        }
                        
                        if openNowSelected || !selectedCategoryIds.isEmpty || selectedRadiusKm != nil || selectedSort != .none || savedOnlySelected {
                            Button {
                                openNowSelected = false
                                selectedCategoryIds.removeAll()
                                selectedRadiusKm = nil
                                selectedSort = .none
                                savedOnlySelected = false
                            } label: {
                            
                                Text("Clear all")
                                    .font(.quicksand(.semiBold, size: 13))
                                    .foregroundColor(Color(.brandCoral))
                                    .padding(.horizontal, 16)
                                    .frame(height: 36)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 56)
            
            // MARK: - Bottom list button
            if selectedPlace == nil {
                VStack {
                    Spacer()
                    Button {
                        // toggle list view — later
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "list.bullet")
                            Text("List")
                                .font(.quicksand(.semiBold, size: 15))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .frame(height: 52)
                        .background(Color(.brandCoral))
                        .cornerRadius(26)
                        .shadow(color: Color(.brandCoral).opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.bottom, 24)
                }
            }
            
            // MARK: - Floating place preview card
            if let place = selectedPlace {
                VStack {
                    Spacer()
                    PlacePreviewCard(
                        place: place,
                        distanceKm: filteredPlaces.first(where: { $0.place.id == place.id })?.distanceKm,
                        isSaved: savedPlacesService.isSaved(place.place.id),
                        onToggleSave: {
                            if let userId = authViewModel.currentUser?.id {
                                Task {
                                    await savedPlacesService.toggleSave(placeId: place.place.id, userId: userId)
                                }
                            }
                        },
                        onClose: { selectedPlace = nil },
                        onExpand: { showPlaceDetail = true }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.92, anchor: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedPlace)
        .task {
            await mapService.loadMapData()
            locationManager.requestLocationPermission()
        }
        .sheet(isPresented: $showTypeFilter) {
            TypeFilterSheet(categories: mapService.categories, selectedCategoryIds: $selectedCategoryIds)
        }
        .sheet(isPresented: $showDistanceFilter) {
            DistanceFilterSheet(selectedRadiusKm: $selectedRadiusKm)
        }
        .sheet(isPresented: $showSortFilter) {
            SortFilterSheet(selectedSort: $selectedSort)
        }
        .fullScreenCover(isPresented: $showPlaceDetail) {
            if let place = selectedPlace {
                PlaceDetailView(place: place)
                    .environmentObject(authViewModel)
                    .environmentObject(savedPlacesService)
            }
        }
        .fullScreenCover(isPresented: $showSearch) {

            SearchView(
                places: mapService.places
            ) { place in

                showSearch = false

                selectedPlace = place

                withAnimation(.easeInOut(duration: 0.45)) {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: place.place.latitude,
                                longitude: place.place.longitude
                            ),
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.015,
                                longitudeDelta: 0.015
                            )
                        )
                    )
                }
            }
        }
    }
}

struct FilterPill: View {
    let title: String
    let icon: String?
    var isSelected: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.quicksand(.semiBold, size: 13))
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 10, weight: .semibold))
                }
            }
            .foregroundColor(isSelected ? .white : Color(.brandBrown))
            .padding(.horizontal, 16)
            .frame(height: 36)
            .fixedSize(horizontal: true, vertical: false)
            .background(
                Group {
                    if isSelected {
                        Color(.brandCoral)
                    } else {
                        Color.white.opacity(0.6)
                    }
                }
            )
            .background {
                if !isSelected {
                    Capsule().fill(.ultraThinMaterial)
                }
            }
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: isSelected
                                ? [Color.clear, Color.clear]
                                : [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color(red: 0.196, green: 0.098, blue: 0.086).opacity(0.10), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    MapView()
        .environmentObject(AuthViewModel())
        .environmentObject(SavedPlacesService())
}
