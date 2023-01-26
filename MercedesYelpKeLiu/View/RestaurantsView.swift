//
//  RestaurantsView.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import SwiftUI

struct RestaurantsView: View {
    
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack {
            if viewModel.didFailToFetchRestaurants {
                errorView()
            } else {
                ZStack {
                    restaurantsView()
                    
                    if viewModel.isFetchingRestaurants {
                        LoadingOverlay(text: "Loading Restaurants...")
                    } else if viewModel.isFetchingReviews {
                        LoadingOverlay(text: "Loading Details...")
                    }
                }
            }
        }
        .navigationTitle("Restaurants")
        .navigationDestination(for: RestaurantDetails.self) { restaurantDetails in
            RestaurantDetailsView(viewModel: viewModel,
                                  restaurantDetails: restaurantDetails)
        }
        .background(Color("theme1_charcoal").edgesIgnoringSafeArea(.all))
        .alert("Sorry, we could not fetch the reviews for this restaurant.",
               isPresented: $viewModel.didFailToFetchReviews) {
            Button("OK") { }
        }
    }
    
    private func restaurantsView() -> some View {
        List(viewModel.restaurants) { restaurant in
            Button {
                viewModel.selectRestaurantIntent(for: restaurant)
            } label: {
                RestaurantTableCellView(viewModel: viewModel,
                                         restaurant: restaurant)
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .onAppear {
                viewModel.handleRestaurantCellDidAppear(for: restaurant)
            }
            .onDisappear {
                viewModel.handleRestaurantCellDidDisappear(for: restaurant)
            }
        }
        .listStyle(.plain)
    }
    
    private func errorView() -> some View {
        ErrorView(text: "Sorry, we could not fill your request, please check your connection and try again...")
    }
}

struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsView(viewModel: ViewModel.mock())
    }
}

