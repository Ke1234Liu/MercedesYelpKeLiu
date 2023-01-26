//
//  RestaurantDetails.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/26/23.
//

import Foundation

struct RestaurantDetails {
    let restaurant: Restaurant
    let reviews: [Review]
}

extension RestaurantDetails: Hashable {
    static func == (lhs: RestaurantDetails, rhs: RestaurantDetails) -> Bool {
        lhs.restaurant.id == rhs.restaurant.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(restaurant.id)
    }
}

extension RestaurantDetails {
    static func mock() -> RestaurantDetails {
        RestaurantDetails(restaurant: Restaurant.mock(), reviews: [Review.mock()])
    }
}
