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
    let time_created: String?
    let rating: Int?
    let text: String?
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
