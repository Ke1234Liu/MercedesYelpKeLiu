//
//  Endpoints.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import Foundation

struct Endpoints {

    struct Endpoint<Response: Decodable> {
        let url: URL
        let responseType: Response.Type
    }
    
    static func restaurants(lat: Double, lon: Double) -> Endpoint<RestaurantsResponse> {
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?limit=20&categories=restaruant&latitude=\(lat)&longitude=\(lon)")!
        return Endpoint(url: url, responseType: RestaurantsResponse.self)
    }
    
    static func reviews(id: String) -> Endpoint<ReviewsResponse> {
        let url = URL(string: "https://api.yelp.com/v3/businesses/\(id)/reviews")!
        return Endpoint(url: url, responseType: ReviewsResponse.self)
    }
}




