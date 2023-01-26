//
//  ReviewTableCellView.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/26/23.
//

import SwiftUI

struct ReviewTableCellView: View {
    @ObservedObject var viewModel: ViewModel
    let review: Review
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack {
                    thumbView()
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text(review.user?.name ?? "???")
                                    .font(.system(size: Device.isIpad ? 28.0 : 20.0).bold())
                                    .foregroundColor(Color("theme1_charcoal"))
                                Spacer()
                            }
                            
                            if let timeCreated = viewModel.dateString(review: review) {
                                HStack {
                                    Text("Date: \(timeCreated)")
                                        .font(.system(size: Device.isIpad ? 22.0 : 16.0))
                                        .foregroundColor(Color("theme1_charcoal"))
                                    Spacer()
                                }
                            }
                            
                            if let rating = viewModel.ratingString(review: review) {
                                HStack {
                                    Text("Rating: \(rating)")
                                        .font(.system(size: Device.isIpad ? 22.0 : 16.0))
                                        .foregroundColor(Color("theme1_charcoal"))
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, Device.isIpad ? 24.0 : 16.0)
                }
            }
            
            if let reviewText = review.text {
                ExpandableParagraph(text: reviewText,
                                    lineLimit: 3)
                .padding(.bottom, Device.isIpad ? 16.0 : 9.0)
            }
            
        }
        .box(backgroundColor: Color("theme1_saffron"),
             strokeColor: Color("theme1_charcoal"),
             cornerRadius: 12.0,
             strokeWidth: Device.isIpad ? 2.0 : 1.0)
        .padding(.horizontal, Device.isIpad ? 24.0 : 16.0)
        .padding(.vertical, Device.isIpad ? 7.0 : 4.0)
    }
    
    func thumbView() -> some View {
        ZStack {
            if let image = viewModel.reviewImage(for: review) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Device.isIpad ? 120.0 : 90.0,
                            height: Device.isIpad ? 120.0 : 90.0)
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
            } else {
                ZStack {
                    if viewModel.reviewImageDownloadError(for: review) {
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

struct ReviewTableCellView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewTableCellView(viewModel: ViewModel.mock(),
                            review: Review.mock())
    }
}
