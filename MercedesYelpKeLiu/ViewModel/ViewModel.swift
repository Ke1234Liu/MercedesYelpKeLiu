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
    
    let restaurantImageBucket = ImageBucket()
    let reviewImageBucket = ImageBucket()
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var navigationPath = NavigationPath()
    
    let app: ApplicationController
    init(app: ApplicationController) {
        self.app = app
        fetchRestaurants()
        
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
                print("Fetch Restaurants Error: \(error.localizedDescription)")
                await MainActor.run {
                    self.isFetchingRestaurants = false
                    self.didFailToFetchRestaurants = true
                }
            }
        }
    }
    
    
    
    //@Published var isFetchingReviews = false
    //@Published var didFailToFetchReviews = false
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
                
                print("_reviews = \(_reviews)")
                
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
    
    /*
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
    */
    
    
    func nameString(restaurant: Restaurant) -> String {
        return restaurant.name
    }
    
    func priceString(restaurant: Restaurant) -> String? {
        return restaurant.price
    }
    
    func phoneString(restaurant: Restaurant) -> String? {
        return restaurant.display_phone
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
