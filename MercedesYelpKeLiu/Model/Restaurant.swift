//
//  Restaurant.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import Foundation

struct RestaurantsResponse: Decodable {
    let businesses: [Restaurant]
}

struct Restaurant: Decodable {
    
    struct Coordinate: Decodable {
        let latitude: Double
        let longitude: Double
    }
    
    struct Location: Decodable {
        let display_address: [String]
    }

    let id: String
    let name: String
    let image_url: String?
    let coordinates: Coordinate?
    let location: Location?
    let review_count: Int?
    let display_phone: String?
    let rating: Double?
    let price: String?
}

extension Restaurant: Identifiable {
    
}

extension Restaurant: Hashable {
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Restaurant {
    static func mock() -> Restaurant {
        Restaurant(id: "001",
                   name: "McDonalds",
                   image_url: "", coordinates: nil, location: nil, review_count: nil, display_phone: nil, rating: nil, price: nil)
    }
    
}
