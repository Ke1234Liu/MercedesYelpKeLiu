//
//  RestaurantsTableCellView.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import SwiftUI

import SwiftUI

struct RestaurantTableCellView: View {
    @ObservedObject var viewModel: ViewModel
    let restaurant: Restaurant
    
    var body: some View {
        HStack {
            HStack {
                thumbView()
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text(restaurant.name)
                                .font(.system(size: Device.isIpad ? 26.0 : 20.0).bold())
                                .foregroundColor(Color("theme1_charcoal"))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        
                        if let price = viewModel.priceString(restaurant: restaurant) {
                            HStack {
                                
                                Text(try! AttributedString(markdown: "Price Range: **\(price)**"))
                                
                                    .font(.system(size: Device.isIpad ? 24.0 : 16.0))
                                    .foregroundColor(Color("theme1_charcoal"))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        
                        if let rating = viewModel.ratingString(restaurant: restaurant) {
                            HStack {
                                Text("Average Rating: \(rating)")
                                    .font(.system(size: Device.isIpad ? 24.0 : 16.0))
                                    .foregroundColor(Color("theme1_charcoal"))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        
                        if let distance = viewModel.distanceString(restaurant: restaurant) {
                            HStack {
                                Text("Distance: \(distance)")
                                    .font(.system(size: Device.isIpad ? 24.0 : 16.0))
                                    .foregroundColor(Color("theme1_charcoal"))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        
                    }
                    Spacer()
                }
                .padding(.vertical, Device.isIpad ? 16.0 : 9.0)
                .padding(.trailing, Device.isIpad ? 24.0 : 16.0)
                .padding(.leading, Device.isIpad ? 6.0 : 4.0)
                
            }
            .box(backgroundColor: Color("theme1_saffron"),
                     strokeColor: Color("theme1_charcoal"),
                     cornerRadius: 12.0,
                     strokeWidth: Device.isIpad ? 2.0 : 1.0)
            .padding(.horizontal, Device.isIpad ? 18.0 : 12.0)
            .padding(.vertical, Device.isIpad ? 5.0 : 3.0)
        }
    }
    
    func thumbView() -> some View {
        ZStack {
            if let image = viewModel.restaurantImage(for: restaurant) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Device.isIpad ? 120.0 : 90.0,
                            height: Device.isIpad ? 120.0 : 90.0)
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
            } else {
                ZStack {
                    if viewModel.restaurantImageDownloadError(for: restaurant) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: Device.isIpad ? 64.0 : 48.0))
                            .foregroundColor(Color("theme1_charcoal"))
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(Color("theme1_charcoal"))
                            .dynamicTypeSize(Device.isIpad ? DynamicTypeSize.xxLarge : DynamicTypeSize.large)
                    }
                }
                .frame(width: Device.isIpad ? 120.0 : 90.0,
                       height: Device.isIpad ? 120.0 : 90.0)
                .box(backgroundColor: Color("theme1_mudslide"),
                         strokeColor: Color("theme1_charcoal"),
                         cornerRadius: 12.0,
                         strokeWidth: Device.isIpad ? 2.0 : 1.0)
            }
        }
        .frame(width: Device.isIpad ? 120.0 : 90.0,
               height: Device.isIpad ? 120.0 : 90.0)
        .padding(.leading, 12.0)
        .padding(.vertical, 12.0)
    }
}

struct RestaurantTableCellView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantTableCellView(viewModel: ViewModel.mock(),
                                 restaurant: Restaurant.mock())
    }
}
