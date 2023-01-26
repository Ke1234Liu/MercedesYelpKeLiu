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
        request.addValue("Bearer OyFRR5PRd5I5hJ1f1ihFkqyANxelEJi0L6T06z3OvrthiWSan7_0ZZSZ_IhganUVxsCMwcxA-qmCeJJGkcyN-zW5CMWm-IVlyc0JZx2Ya92MU6Smr9OTuHuoy2EzY3Yx", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
        
        return try decoder.decode(ResponseType.self, from: data)
    }
}
