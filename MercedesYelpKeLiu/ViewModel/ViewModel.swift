//
//  ViewModel.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import Foundation
import SwiftUI
import Combine

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
    
    @Published var isFetchingReviews = false
    @Published var didFailToFetchReviews = false
    
    private let restaurantImageBucket = ImageBucket()
    private let reviewImageBucket = ImageBucket()
    
    private let locationManager = LocationManager()
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var navigationPath = NavigationPath()
    
    let app: ApplicationController
    init(app: ApplicationController) {
        self.app = app
        
        isFetchingRestaurants = true
        
        restaurantImageBucket.publisher
            .receive(on: OperationQueue.main)
            .sink { _ in
                
            } receiveValue: { val in
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
        reviewImageBucket.publisher
            .receive(on: OperationQueue.main)
            .sink { _ in
                
            } receiveValue: { val in
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
        locationManager.publisher
            .receive(on: OperationQueue.main)
            .sink { _ in
                
            } receiveValue: { _ in
                if let lat = self.locationManager.lat, let lon = self.locationManager.lon {
                    self.fetchRestaurants(lat: lat,
                                          lon: lon)
                } else {
                    self.fetchRestaurants(lat: ApplicationController.defaultLat,
                                          lon: ApplicationController.defaultLon)
                }
            }
            .store(in: &subscriptions)
        locationManager.startObservingLocation()
    }
    
    private var fetchRestaurantsTask: Task<Void, Never>?
    func fetchRestaurants(lat: Double, lon: Double) {
        fetchRestaurantsTask?.cancel()
        fetchRestaurantsTask = Task {
            await MainActor.run {
                self.isFetchingRestaurants = true
                self.didFailToFetchRestaurants = false
            }
            do {
                let _restaurants = try await app.network.download(endpoint: Endpoints.restaurants(lat: lat,
                                                                                                  lon: lon))
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
                print("Fetch Restaurants Error: \(error.localizedDescription)")
                await MainActor.run {
                    self.isFetchingRestaurants = false
                    self.didFailToFetchRestaurants = true
                }
            }
        }
    }
    
    private var fetchReviewsTask: Task<Void, Never>?
    func fetchReviews(for restaurant: Restaurant) {
        fetchReviewsTask?.cancel()
        fetchReviewsTask = Task {
            await MainActor.run {
                self.isFetchingReviews = true
                self.didFailToFetchReviews = false
            }
            do {
                let _reviews = try await app.network.download(endpoint: Endpoints.reviews(id: restaurant.id))
                    .reviews
                
                if Task.isCancelled {
                    await MainActor.run {
                        self.isFetchingReviews = false
                    }
                    return
                }
                
                await MainActor.run {
                    self.isFetchingReviews = false
                    self.didFailToFetchReviews = false
                    
                    let restaurantDetails = RestaurantDetails(restaurant: restaurant, reviews: _reviews)
                    navigationPath.append(restaurantDetails)
                }
            } catch let error {
                print("Fetch Reviews Error: \(error.localizedDescription)")
                await MainActor.run {
                    self.isFetchingReviews = false
                    self.didFailToFetchReviews = true
                }
            }
        }
    }
    
    func selectRestaurantIntent(for restaurant: Restaurant) {
        fetchReviews(for: restaurant)
    }
    
    func handleRestaurantCellDidAppear(for restaurant: Restaurant) {
        if let urlString = restaurant.image_url, let url = URL(string: urlString) {
            restaurantImageBucket.handleEnter(for: restaurant, withURL: url)
        } else {
            restaurantImageBucket.handleMissing(for: restaurant)
        }
    }
    
    func handleRestaurantCellDidDisappear(for restaurant: Restaurant) {
        restaurantImageBucket.handleLeave(for: restaurant)
    }
    
    func restaurantImage(for restaurant: Restaurant) -> UIImage? {
        return restaurantImageBucket.image(for: restaurant)
    }
    
    func restaurantImageDownloadError(for restaurant: Restaurant) -> Bool {
        return restaurantImageBucket.imageDownloadError(for: restaurant)
    }
    
    func handleReviewCellDidAppear(for review: Review) {
        if let urlString = review.user?.image_url, let url = URL(string: urlString) {
            reviewImageBucket.handleEnter(for: review, withURL: url)
        } else {
            reviewImageBucket.handleMissing(for: review)
        }
    }
    
    func handleReviewCellDidDisappear(for review: Review) {
        reviewImageBucket.handleLeave(for: review)
    }
    
    func reviewImage(for review: Review) -> UIImage? {
        return reviewImageBucket.image(for: review)
    }
    
    func reviewImageDownloadError(for review: Review) -> Bool {
        return reviewImageBucket.imageDownloadError(for: review)
    }
    
    func nameString(restaurant: Restaurant) -> String {
        return restaurant.name
    }
    
    func priceString(restaurant: Restaurant) -> String? {
        return restaurant.price
    }
    
    func phoneString(restaurant: Restaurant) -> String? {
        return restaurant.display_phone
    }
    
    func distanceString(restaurant: Restaurant) -> String? {
        if let distance = restaurant.distance {
            return String(format: "%.1f km", distance / 1000.0)
        }
        return nil
    }
    
    func addressString(restaurant: Restaurant) -> String? {
        if let addressArray = restaurant.location?.display_address {
            if addressArray.count > 0 {
                return addressArray[0]
            }
        }
        return nil
    }
    
    func ratingString(restaurant: Restaurant) -> String? {
        if let rating = restaurant.rating {
            return String(format: "%.1f", rating)
        }
        return nil
    }
    
    func ratingString(review: Review) -> String? {
        if let rating = review.rating {
            return String(rating)
        }
        return nil
    }
    
    func dateString(review: Review) -> String? {
        if let result = review.time_created {
            if result.count >= 10 {
                return String(result.prefix(10))
            }
        }
        return nil
    }
}
