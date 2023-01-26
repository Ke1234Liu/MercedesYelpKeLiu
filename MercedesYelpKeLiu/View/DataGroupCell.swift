//
//  DataGroupCell.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import SwiftUI

struct DataGroupCell: View {
    let dataGroup: DataGroup
    var body: some View {
        VStack {
            Spacer()
                .frame(height: Device.isIpad ? 16.0 : 10.0)
            
            HStack {
                Text("\(dataGroup.title):")
                    .font(.system(size: 22.0).bold())
                    .foregroundColor(Color("theme2_salmon"))
                
                Spacer()
            }
            
            Spacer()
                .frame(height: Device.isIpad ? 6.0 : 2.0)
            
            HStack {
                Text(dataGroup.value)
                    .font(.system(size: 22.0).bold())
                    .foregroundColor(Color("theme2_banana"))
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

struct DataGroupCell_Previews: PreviewProvider {
    static var previews: some View {
        
        
        VStack(spacing: 0.0) {
            
            Spacer()
            
            DataGroupTitledView(title: "My Data Group...", dataGroups: [
                DataGroup(id: 0, title: "Coolant Temperature", value: "850.000K"),
                DataGroup(id: 1, title: "Velocity", value: "33 m/s"),
                DataGroup(id: 2, title: "Label A", value: "Value A"),
                DataGroup(id: 3, title: "Micro-Killo-Pascalls", value: "500,000.0"),
                DataGroup(id: 4, title: "Final Column, Which Has a Long Long Title", value: "Value, which is Also a Long Long Value..."),
                DataGroup(id: 5, title: "H/C", value: "80")
            
            ])
            
            Spacer()
        }
        .background(Color("theme1_charcoal"))
    }
}
