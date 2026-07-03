//
//  MapService.swift
//  ParentsMap
//
//  Created by Mariia on 19/6/2026.
//
import Foundation
import Supabase
import CoreLocation


@MainActor
class MapService: ObservableObject {
    @Published var places: [PlaceWithDetails] = []
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Fetch all approved places with their category and tags
    func fetchPlaces() async {
        isLoading = true
        errorMessage = nil
        do {
            let placesData: [Place] = try await supabase
                .from("places")
                .select()
                .eq("is_approved", value: true)
                .execute()
                .value
            
            print("✅ Fetched \(placesData.count) places")
            
            var detailedPlaces: [PlaceWithDetails] = []
            for place in placesData {
                let tags = await fetchTags(for: place.id)
                let category = categories.first { $0.id == place.categoryId }
                detailedPlaces.append(PlaceWithDetails(place: place, category: category, tags: tags))
            }
            self.places = detailedPlaces
            
            print("✅ Created \(detailedPlaces.count) detailed places")
            
        } catch {
            print("❌ Error fetching places: \(error)")
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // Fetch categories (Parent Room, Bench, Shaded Area)
    func fetchCategories() async {
        do {
            let data: [Category] = try await supabase
                .from("categories")
                .select()
                .execute()
                .value
            self.categories = data
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Fetch tags for a specific place via the join table
    func fetchTags(for placeId: Int) async -> [Tag] {
        do {
            struct PlaceTagJoin: Codable {
                let tags: Tag
            }
            let data: [PlaceTagJoin] = try await supabase
                .from("place_tags")
                .select("tags(*)")
                .eq("place_id", value: placeId)
                .execute()
                .value
            return data.map { $0.tags }
        } catch {
            print("Could not load tags for place \(placeId): \(error)")
            return []
        }
    }
    
    // Load everything needed for the map screen
    func loadMapData() async {
        await fetchCategories()
        await fetchPlaces()
        
    }
    // distance filter
    func distance(from userLocation: CLLocationCoordinate2D?, to place: Place) -> Double? {
        guard let userLocation = userLocation else { return nil }
        let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let placeLoc = CLLocation(latitude: place.latitude, longitude: place.longitude)
        return userLoc.distance(from: placeLoc) / 1000 // convert metres to km
    }
    // open now filter
    func isOpenNow(_ place: Place) -> Bool {
        guard let hours = place.openingHours else { return true } // no hours = assume always open
        
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now) // 1 = Sunday, 2 = Monday...
        
        let dayString: String?
        switch weekday {
        case 1: dayString = hours.sun
        case 2: dayString = hours.mon
        case 3: dayString = hours.tue
        case 4: dayString = hours.wed
        case 5: dayString = hours.thu
        case 6: dayString = hours.fri
        case 7: dayString = hours.sat
        default: dayString = nil
        }
        
        guard let todayHours = dayString else { return false }
        
        if todayHours.lowercased().contains("24 hours") {
            return true
        }
        
        // Parse formats like "8am-4pm" or "7am-10pm"
        let parts = todayHours.lowercased().replacingOccurrences(of: " ", with: "").split(separator: "-")
        guard parts.count == 2,
              let openTime = parseTime(String(parts[0])),
              let closeTime = parseTime(String(parts[1])) else {
            return true // if we can't parse it, don't block the user
        }
        
        let currentMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
        return currentMinutes >= openTime && currentMinutes <= closeTime
    }

    private func parseTime(_ string: String) -> Int? {
        // Parses "8am" or "10pm" into minutes since midnight
        var hour = 0
        var isPM = false
        var cleaned = string
        
        if cleaned.hasSuffix("pm") {
            isPM = true
            cleaned = String(cleaned.dropLast(2))
        } else if cleaned.hasSuffix("am") {
            cleaned = String(cleaned.dropLast(2))
        }
        
        guard let parsedHour = Int(cleaned) else { return nil }
        hour = parsedHour
        
        if isPM && hour != 12 {
            hour += 12
        } else if !isPM && hour == 12 {
            hour = 0
        }
        
        return hour * 60
    }
}

// Combines a Place with its resolved category and tags
struct PlaceWithDetails: Identifiable, Hashable {
    let place: Place
    let category: Category?
    let tags: [Tag]
    
    var id: Int { place.id }
    
    static func == (lhs: PlaceWithDetails, rhs: PlaceWithDetails) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
