//
//  Place.swift
//  ParentsMap
//
//  Created by Mariia on 10/6/2026.
//

import Foundation

struct Place: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    let address: String?
    let latitude: Double
    let longitude: Double
    let categoryId: Int?
    let averageRating: Double?
    let reviewCount: Int?
    let isApproved: Bool?
    let phone: String?
    let website: String?
    let openingHours: OpeningHours?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, address, latitude, longitude
        case categoryId = "category_id"
        case averageRating = "average_rating"
        case reviewCount = "review_count"
        case isApproved = "is_approved"
        case phone, website
        case openingHours = "opening_hours"
    }
}

struct OpeningHours: Codable {
    let mon: String?
    let tue: String?
    let wed: String?
    let thu: String?
    let fri: String?
    let sat: String?
    let sun: String?
}

struct Category: Identifiable, Codable {
    let id: Int
    let name: String
    let icon: String?
}

struct Tag: Identifiable, Codable {
    let id: Int
    let name: String
    let icon: String?
    let category: String?
}

struct Review: Identifiable, Codable {
    let id: Int
    let placeId: Int
    let userId: UUID
    let rating: Int
    let comment: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeId = "place_id"
        case userId = "user_id"
        case rating, comment
        case createdAt = "created_at"
    }
}

struct UserProfile: Identifiable, Codable {
    let id: UUID
    let fullName: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case avatarUrl = "avatar_url"
    }
}
