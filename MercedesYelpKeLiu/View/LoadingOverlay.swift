//
//  LoadingOverlay.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import SwiftUI

struct LoadingOverlay: View {
    
    let text: String
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: Device.isIpad ? 24.0 : 16.0) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.white)
                        .dynamicTypeSize(Device.isIpad ? DynamicTypeSize.xxxLarge : DynamicTypeSize.xLarge)
                        .scaleEffect(CGSize(width: 1.65, height: 1.65))
                    
                    HStack {
                        Text(text)
                            .font(.system(size: Device.isIpad ? 24.0 : 16.0).bold())
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: 200.0)
                }
                Spacer()
            }
            Spacer()
        }
        .background(Color("theme1_charcoal").opacity(0.88))
    }
}

struct LoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlay(text: "Loading Launch Details")
    }
}
