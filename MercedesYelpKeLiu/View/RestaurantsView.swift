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
                    
                    //TODO: detail page
                    if viewModel.isFetchingRestaurants || viewModel.isFetchingRestaurants {
                        LoadingOverlay(text: "Loading...")
                    }
                }
            }
        }
        .background(Color("theme1_charcoal").edgesIgnoringSafeArea(.all))
    }
    
    private func errorView() -> some View {
        ErrorView(text: "Unable to fetch launches, please try again...")
    }
    
    private func restaurantsView() -> some View {
        List(viewModel.restaurants) { restaurant in
            Button {
                viewModel.selectRestaurantIntent(for: restaurant)
            } label: {
                RestaurantsTableCellView(viewModel: viewModel,
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
}

struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsView(viewModel: ViewModel.mock())
    }
}

