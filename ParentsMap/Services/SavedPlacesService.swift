//
//  SavedPlacesService.swift
//  ParentsMap
//
//  Created by Mariia on 25/6/2026.
//

import Foundation
import Supabase

@MainActor
class SavedPlacesService: ObservableObject {
    @Published var savedPlaceIds: Set<Int> = []
    @Published var errorMessage: String?
    
    struct SavedPlaceInsert: Encodable {
        let user_id: String
        let place_id: Int
    }
    
    struct SavedRow: Codable {
        let place_id: Int
    }
    
    func loadSavedPlaceIds(userId: UUID) async {
        do {
            let data: [SavedRow] = try await supabase
                .from("saved_places")
                .select("place_id")
                .eq("user_id", value: userId.uuidString)
                .execute()
                .value
            self.savedPlaceIds = Set(data.map { $0.place_id })
            print("✅ Loaded saved places: \(self.savedPlaceIds)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Failed to load saved places: \(error)")
        }
    }
    
    func isSaved(_ placeId: Int) -> Bool {
        savedPlaceIds.contains(placeId)
    }
    
    
    func toggleSave(placeId: Int, userId: UUID) async {
        if savedPlaceIds.contains(placeId) {
            do {
                try await supabase
                    .from("saved_places")
                    .delete()
                    .eq("user_id", value: userId.uuidString)
                    .eq("place_id", value: placeId)
                    .execute()
                savedPlaceIds.remove(placeId)
            } catch {
                errorMessage = error.localizedDescription
            }
        } else {
            do {
                try await supabase
                    .from("saved_places")
                    .insert(SavedPlaceInsert(user_id: userId.uuidString, place_id: placeId))
                    .execute()
                savedPlaceIds.insert(placeId)
            } catch {
                // If it's already saved in the DB (duplicate key), just sync local state to match
                if error.localizedDescription.contains("duplicate key") {
                    savedPlaceIds.insert(placeId)
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
