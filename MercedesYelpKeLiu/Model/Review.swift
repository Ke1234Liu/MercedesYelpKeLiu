//
//  Review.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import Foundation

struct ReviewsResponse: Decodable {
    let reviews: [Review]
}

struct Review: Decodable {
    struct User: Decodable {
        let id: String
        let image_url: String?
        let name: String?
    }
    let id: String
    let text: String?
    let time_created: String?
    let rating: Int?
    let user: User?
}

extension Review: Identifiable {
    
}

extension Review: Hashable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Review {
    static func mock() -> Review {
        let jsonString = "{\n\t\"id\": \"4a56CcYf-Ul1Cyr5cgJDCQ\",\n\t\"url\": \"https://www.yelp.com/biz/long-beach-creamery-long-beach-2?adjust_creative=eRaZef2RzQTJQkpUADwVCQ&hrid=4a56CcYf-Ul1Cyr5cgJDCQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_reviews&utm_source=eRaZef2RzQTJQkpUADwVCQ\",\n\t\"text\": \"Awesome and unique flavors of ice cream.  \\n\\nThe staff was super helpful and really knew their ice cream and enthusiastically gave us sample of all of them....\",\n\t\"rating\": 5,\n\t\"time_created\": \"2022-10-07 01:29:18\",\n\t\"user\": {\n\t\t\"id\": \"iP0jK9FiAJ5MVC2YU7uVEw\",\n\t\t\"profile_url\": \"https://www.yelp.com/user_details?userid=iP0jK9FiAJ5MVC2YU7uVEw\",\n\t\t\"image_url\": \"https://s3-media4.fl.yelpcdn.com/photo/V7Euooll7gOgoZBW6TP5Hw/o.jpg\",\n\t\t\"name\": \"David H.\"\n\t}\n}"
        let jsonData = jsonString.data(using: .utf8)!
        return try! JSONDecoder().decode(Review.self, from: jsonData)
    }
}
