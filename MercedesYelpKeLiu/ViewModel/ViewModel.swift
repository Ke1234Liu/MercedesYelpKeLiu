//
//  ViewModel.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    private enum ImageDownloadError: Error {
        case invalidDimension
    }
    
    static func mock() -> ViewModel {
        ViewModel(app: ApplicationController.mock())
    }
    
    @Published var isFetchingRestaurants = false
    @Published var restaurants = [Restaurant]()
    @Published var didFailToFetchRestaurants = false
    
    @Published var navigationPath = NavigationPath()
    
    let app: ApplicationController
    init(app: ApplicationController) {
        self.app = app
        fetchRestaurants()
    }
    
    private var fetchRestaurantsTask: Task<Void, Never>?
    func fetchRestaurants() {
        
        fetchRestaurantsTask?.cancel()
        fetchRestaurantsTask = Task {
            
            await MainActor.run {
                self.isFetchingRestaurants = true
                self.didFailToFetchRestaurants = false
            }
            
            do {
                let _restaurants = try await app.network.download(endpoint: Endpoints.restaurants(lat: ApplicationController.defaultLat,
                                                                                                  lon: ApplicationController.defaultLon))
                    .businesses
                
                if Task.isCancelled {
                    await MainActor.run {
                        self.isFetchingRestaurants = false
                    }
                    return
                }
                
                if _restaurants.count <= 0 {
                    await MainActor.run {
                        self.isFetchingRestaurants = false
                        self.didFailToFetchRestaurants = true
                    }
                    return
                }
                
                await MainActor.run {
                    self.isFetchingRestaurants = false
                    self.didFailToFetchRestaurants = false
                    self.restaurants = _restaurants
                }
            } catch let error {
                await MainActor.run {
                    self.isFetchingRestaurants = false
                    self.didFailToFetchRestaurants = true
                }
            }
        }
    }
    
    func selectRestaurantIntent(for restaurant: Restaurant) {
        
    }
    
    func image(for restaurant: Restaurant) -> UIImage? {
        return _restaurantImageDict[restaurant]
    }
    
    func imageDownloadError(for restaurant: Restaurant) -> Bool {
        return _incapableThumbDownloadingRestaurantSet.contains(restaurant)
    }
    
    private var _restaurantImageDict = [Restaurant: UIImage]()
    private var _activelyDownloadingThumbTasks = [Restaurant: Task<Void, Never>]()
    private var _incapableThumbDownloadingRestaurantSet = Set<Restaurant>()
    
    func handleRestaurantCellDidAppear(for restaurant: Restaurant) {
        
        // Start downloading the image, only if we need to...
        if _incapableThumbDownloadingRestaurantSet.contains(restaurant) { return }
        if _activelyDownloadingThumbTasks[restaurant] != nil { return }
        if _restaurantImageDict[restaurant] != nil { return }
        
        // Can we get a functional url?
        var url: URL?
        if let urlString = restaurant.image_url {
            url = URL(string: urlString)
        }
        
        guard let url = url else {
            _incapableThumbDownloadingRestaurantSet.insert(restaurant)
            return
        }
        
        _activelyDownloadingThumbTasks[restaurant] = Task {
            do {
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let image = UIImage(data: data) else {
                    throw URLError(.cannotDecodeRawData)
                }
                guard image.size.width > 0.0 && image.size.height > 0.0 else {
                    throw ImageDownloadError.invalidDimension
                }
                
                await MainActor.run {
                    _incapableThumbDownloadingRestaurantSet.remove(restaurant)
                    _activelyDownloadingThumbTasks.removeValue(forKey: restaurant)
                    _restaurantImageDict[restaurant] = image
                    
                    self.objectWillChange.send()
                }
                
            } catch let error {
                print("thumb download error: \(error.localizedDescription)")
                print("thumb download url: \(url)")
                
                if Task.isCancelled {
                    await MainActor.run {
                        _incapableThumbDownloadingRestaurantSet.remove(restaurant)
                        _activelyDownloadingThumbTasks.removeValue(forKey: restaurant)
                    }
                    return
                } else {
                    await MainActor.run {
                        _incapableThumbDownloadingRestaurantSet.insert(restaurant)
                        _activelyDownloadingThumbTasks.removeValue(forKey: restaurant)
                        self.objectWillChange.send()
                    }
                }
            }
        }
    }
    
    func handleRestaurantCellDidDisappear(for restaurant: Restaurant) {
        // Stop downloading the patch...
        _activelyDownloadingThumbTasks[restaurant]?.cancel()
        _incapableThumbDownloadingRestaurantSet.remove(restaurant)
    }
    
    
    func nameString(for restaurant: Restaurant) -> String {
        return restaurant.name
    }
    
    
}

