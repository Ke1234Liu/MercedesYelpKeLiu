//
//  ErrorView.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import SwiftUI

struct ErrorView: View {
    let text: String
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(spacing: Device.isIpad ? 24.0 : 16.0) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: Device.isIpad ? 80.0 : 54.0))
                        .tint(Color("theme1_saffron"))
                    
                    HStack {
                        Text(text)
                            .font(.system(size: Device.isIpad ? 24.0 : 16.0).bold())
                    }
                    .frame(maxWidth: 220.0)
                }
                .foregroundColor(Color("theme1_saffron"))
                Spacer()
            }
            
            Spacer()
        }
        .background(Color("theme1_charcoal"))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(text: "Unable to fetch restaurants, please try again...")
    }
}

