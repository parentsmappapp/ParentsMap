import Foundation
import Supabase
import CoreLocation
import UIKit

@MainActor
class SubmitPlaceService: ObservableObject {
    @Published var categories: [Category] = []
    @Published var tags: [Tag] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSubmitSuccessfully = false
    
    struct SubmissionInsert: Encodable {
        let name: String
        let description: String?
        let address: String
        let latitude: Double
        let longitude: Double
        let category_id: Int
        let submitted_by: String
        let phone: String?
        let website: String?
        let tag_ids: [Int]
    }
    
    func loadFormData() async {
        do {
            let cats: [Category] = try await supabase
                .from("categories")
                .select()
                .execute()
                .value
            self.categories = cats
            
            let allTags: [Tag] = try await supabase
                .from("tags")
                .select()
                .execute()
                .value
            self.tags = allTags
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func groupedTags(for categoryName: String) -> [(category: String, tags: [Tag])] {
        let relevantCategories: [String]
        switch categoryName {
        case "Parent Room":
            relevantCategories = ["Toileting", "Feeding", "Hygiene", "Other"]
        default:
            relevantCategories = ["Comfort", "Facilities Nearby"]
        }
        let relevant = tags.filter { relevantCategories.contains($0.category ?? "") }
        let grouped = Dictionary(grouping: relevant, by: { $0.category ?? "Other" })
        return relevantCategories.compactMap { key in
            guard let group = grouped[key] else { return nil }
            return (category: key, tags: group)
        }
    }
    
    func geocodeAddress(_ address: String) async -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            return placemarks.first?.location?.coordinate
        } catch {
            return nil
        }
    }
    
    func reverseGeocode(_ coordinate: CLLocationCoordinate2D) async -> String? {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return nil }
            let parts = [
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.postalCode
            ].compactMap { $0 }
            return parts.joined(separator: " ")
        } catch {
            return nil
        }
    }
    
    func uploadPhotos(_ images: [UIImage], submissionId: Int) async {
        for image in images {
            guard let data = image.jpegData(compressionQuality: 0.7) else { continue }
            let fileName = "\(UUID().uuidString).jpg"
            do {
                _ = try await supabase.storage
                    .from("place-photos")
                    .upload(fileName, data: data)
                
                let publicURL = try supabase.storage
                    .from("place-photos")
                    .getPublicURL(path: fileName)
                
                struct PhotoInsert: Encodable {
                    let place_id: Int?
                    let photo_url: String
                }
                try await supabase
                    .from("place_photos")
                    .insert(PhotoInsert(place_id: nil, photo_url: publicURL.absoluteString))
                    .execute()
            } catch {
                print("❌ Photo upload failed: \(error)")
            }
        }
    }
    
    func submit(
        name: String,
        description: String,
        address: String,
        coordinate: CLLocationCoordinate2D,
        phone: String,
        website: String,
        categoryId: Int,
        selectedTagIds: Set<Int>,
        userId: UUID
    ) async -> Int? {
        isLoading = true
        errorMessage = nil
        
        let insert = SubmissionInsert(
            name: name,
            description: description.isEmpty ? nil : description,
            address: address,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            category_id: categoryId,
            submitted_by: userId.uuidString,
            phone: phone.isEmpty ? nil : phone,
            website: website.isEmpty ? nil : website,
            tag_ids: Array(selectedTagIds)
        )
        
        do {
            struct InsertedId: Decodable { let id: Int }
            let inserted: [InsertedId] = try await supabase
                .from("place_submissions")
                .insert(insert)
                .select("id")
                .execute()
                .value
            didSubmitSuccessfully = true
            isLoading = false
            return inserted.first?.id
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return nil
        }
    }
}
