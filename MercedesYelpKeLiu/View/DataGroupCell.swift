//
//  DataGroupCell.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import SwiftUI

struct DataGroupCell: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: Device.isIpad ? 16.0 : 10.0)
            HStack {
                HStack {
                    Text("\(title):")
                        .font(.system(size: 22.0).bold())
                        .foregroundColor(Color("theme2_salmon"))
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text(value)
                        .font(.system(size: 22.0).bold())
                        .foregroundColor(Color("theme2_banana"))
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            Spacer()
                .frame(height: Device.isIpad ? 16.0 : 10.0)
        }
        .padding(.horizontal, Device.isIpad ? 24.0 : 16.0)
        .box(backgroundColor: Color("theme2_yale"),
                 strokeColor: Color("theme1_saffron"),
                 cornerRadius: 12.0,
                 strokeWidth: Device.isIpad ? 6.0 : 3.0)
        .padding(.horizontal, Device.isIpad ? 24.0 : 16.0)
    }
}

