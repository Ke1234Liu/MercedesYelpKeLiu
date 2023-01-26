//
//  NetworkManager.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import Foundation

class NetworkManager {
    
    lazy var decoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    func download<ResponseType>(endpoint: Endpoints.Endpoint<ResponseType>) async throws -> ResponseType {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: endpoint.url)
        
        request.addValue("Bearer ij23kGKlMAawSWmwsLD9DMhPLulo2KJccz6G1phAYPBYH9Smek8MsQnSBNVoe_8QEvVte8jvE0Si_LkghIHfAJSDNEJwozGGGznYQFYzwefzuZqAB-aJ0GqEIUHRY3Yx", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(ResponseType.self, from: data)
    }
}
