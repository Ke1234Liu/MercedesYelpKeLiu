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
        
        let jsonString = "{\n\t\"id\": \"txWL7W11htEsFRNFhffwRg\",\n\t\"alias\": \"long-beach-creamery-long-beach-2\",\n\t\"name\": \"Long Beach Creamery\",\n\t\"image_url\": \"https://s3-media1.fl.yelpcdn.com/bphoto/OoLWzB8A9doptsvSprVpIQ/o.jpg\",\n\t\"is_closed\": false,\n\t\"url\": \"https://www.yelp.com/biz/long-beach-creamery-long-beach-2?adjust_creative=eRaZef2RzQTJQkpUADwVCQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=eRaZef2RzQTJQkpUADwVCQ\",\n\t\"review_count\": 1139,\n\t\"categories\": [{\n\t\t\"alias\": \"icecream\",\n\t\t\"title\": \"Ice Cream & Frozen Yogurt\"\n\t}],\n\t\"rating\": 4.5,\n\t\"coordinates\": {\n\t\t\"latitude\": 33.83335,\n\t\t\"longitude\": -118.18971\n\t},\n\t\"transactions\": [\"pickup\", \"delivery\"],\n\t\"price\": \"$$\",\n\t\"location\": {\n\t\t\"address1\": \"4141 Long Beach Blvd\",\n\t\t\"address2\": \"\",\n\t\t\"address3\": \"\",\n\t\t\"city\": \"Long Beach\",\n\t\t\"zip_code\": \"90807\",\n\t\t\"country\": \"US\",\n\t\t\"state\": \"CA\",\n\t\t\"display_address\": [\"4141 Long Beach Blvd\", \"Long Beach, CA 90807\"]\n\t},\n\t\"phone\": \"+15625133493\",\n\t\"display_phone\": \"(562) 513-3493\",\n\t\"distance\": 2099.7564812909172\n}"
        
        let jsonData = jsonString.data(using: .utf8)!
        return try! JSONDecoder().decode(Restaurant.self, from: jsonData)
    }
}
