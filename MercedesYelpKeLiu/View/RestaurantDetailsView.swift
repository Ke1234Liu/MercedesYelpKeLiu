//
//  RestaurantDetailsView.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/26/23.
//

import SwiftUI

struct RestaurantDetailsView: View {
    
    @ObservedObject var viewModel: ViewModel
    let restaurantDetails: RestaurantDetails
    var body: some View {
        
        ScrollView {
            VStack {
                
                if let image = viewModel.restaurantImage(for: restaurantDetails.restaurant) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, minHeight: 170, idealHeight: 210, maxHeight: 220)
                        .clipped()
                }
                
                informationView()
                
                if restaurantDetails.reviews.count > 0 {
                    reviewsView()
                }
            }
        }
        .background(Color("theme1_charcoal"))
        .navigationTitle("Restaurant Details")
    }
    
    func informationView() -> some View {
        
        VStack {
            HStack {
                Spacer()
                Text(viewModel.nameString(restaurant: restaurantDetails.restaurant))
                    .font(.system(size: Device.isIpad ? 44.0 : 32.0).bold())
                    .foregroundColor(Color("theme1_saffron"))
                Spacer()
            }
            .padding(.top, Device.isIpad ? 18.0 : 12.0)
            .padding(.horizontal, Device.isIpad ? 18.0 : 12.0)
            VStack(spacing: Device.isIpad ? 12.0 : 8.0) {
                
                if let address = viewModel.addressString(restaurant: restaurantDetails.restaurant) {
                    DataGroupCell(title: "Address", value: address)
                }
                
                if let rating = viewModel.ratingString(restaurant: restaurantDetails.restaurant) {
                    DataGroupCell(title: "Rating", value: rating)
                }
                
                if let price = viewModel.priceString(restaurant: restaurantDetails.restaurant) {
                    DataGroupCell(title: "Price", value: price)
                }
                
                if let phone = viewModel.phoneString(restaurant: restaurantDetails.restaurant) {
                    DataGroupCell(title: "Phone", value: phone)
                }
            }
            .padding(.bottom, Device.isIpad ? 24.0 : 16.0)
        }
        .box(backgroundColor: Color("theme2_royal"),
             strokeColor: Color("theme1_saffron"),
             cornerRadius: 12.0,
             strokeWidth: Device.isIpad ? 6.0 : 3.0)
        .padding(.horizontal, Device.isIpad ? 24.0 : 16.0)
        .padding(.vertical, Device.isIpad ? 6.0 : 4.0)
    }
    
    func reviewsView() -> some View {
        
        VStack {
            HStack {
                Spacer()
                Text("Reviews")
                    .font(.system(size: Device.isIpad ? 44.0 : 32.0).bold())
                    .foregroundColor(Color("theme1_saffron"))
                Spacer()
            }
            .padding(.vertical, Device.isIpad ? 18.0 : 12.0)
            .padding(.horizontal, Device.isIpad ? 18.0 : 12.0)
            VStack(spacing: Device.isIpad ? 12.0 : 8.0) {
                ForEach(restaurantDetails.reviews) { review in
                    reviewCellView(review: review)
                }
            }
            .padding(.bottom, Device.isIpad ? 24.0 : 16.0)
        }
        .box(backgroundColor: Color("theme2_royal"),
             strokeColor: Color("theme1_saffron"),
             cornerRadius: 12.0,
             strokeWidth: Device.isIpad ? 6.0 : 3.0)
        .padding(.horizontal, Device.isIpad ? 24.0 : 16.0)
        .padding(.vertical, Device.isIpad ? 6.0 : 4.0)
        
    }
    
    func reviewCellView(review: Review) -> some View {
        ReviewTableCellView(viewModel: viewModel,
                            review: review)
        .onAppear {
            viewModel.handleReviewCellDidAppear(for: review)
        }
        .onDisappear {
            viewModel.handleReviewCellDidDisappear(for: review)
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailsView(viewModel: ViewModel.mock(),
                              restaurantDetails: RestaurantDetails.mock())
    }
}

