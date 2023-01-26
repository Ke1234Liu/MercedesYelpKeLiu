//
//  RestaurantsTableCellView.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

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
                        Text(restaurant.name)
                            .font(.system(size: Device.isIpad ? 42.0 : 32.0))
                            .foregroundColor(Color("theme1_charcoal"))
                        Text(restaurant.id)
                            .font(.system(size: Device.isIpad ? 34.0 : 26.0))
                            .foregroundColor(Color("theme1_charcoal"))
                    }
                    Spacer()
                }
                .padding(.vertical, Device.isIpad ? 16.0 : 9.0)
                .padding(.horizontal, Device.isIpad ? 24.0 : 16.0)
            }
            .box(backgroundColor: Color("theme1_saffron"),
                     strokeColor: Color("theme1_charcoal"),
                     cornerRadius: 12.0,
                     strokeWidth: Device.isIpad ? 6.0 : 3.0)
            .padding(.horizontal, Device.isIpad ? 24.0 : 16.0)
            .padding(.vertical, Device.isIpad ? 7.0 : 4.0)
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
                         strokeWidth: Device.isIpad ? 6.0 : 3.0)
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
