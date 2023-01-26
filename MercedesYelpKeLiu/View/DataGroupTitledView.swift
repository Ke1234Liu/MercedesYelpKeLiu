//
//  DataGroupTitledView.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import SwiftUI

struct DataGroupTitledView: View {
    let title: String
    let dataGroups: [DataGroup]
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: Device.isIpad ? 44.0 : 32.0).bold())
                    .foregroundColor(Color("theme1_saffron"))
                Spacer()
            }
            .padding(.vertical, Device.isIpad ? 18.0 : 12.0)
            .padding(.horizontal, Device.isIpad ? 18.0 : 12.0)
            VStack(spacing: Device.isIpad ? 12.0 : 8.0) {
                ForEach(dataGroups) { dataGroup in
                    DataGroupCell(dataGroup: dataGroup)
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
}

struct DataGroupTitledView_Previews: PreviewProvider {
    static var previews: some View {
        VStack (spacing: 0.0) {
            Spacer()
            DataGroupTitledView(title: "Engine Specifications",
                                dataGroups: [DataGroup(id: 0, title: "Coolant Temperature", value: "850.000K"),
                                             DataGroup(id: 1, title: "Velocity", value: "33 m/s")])
            DataGroupTitledView(title: "Another Group",
                                dataGroups: [DataGroup(id: 0, title: "Label A", value: "Value A"),
                                             DataGroup(id: 1, title: "Micro-Killo-Pascalls", value: "500,000.0"),
                                             DataGroup(id: 2, title: "H/C", value: "80"),
                                             DataGroup(id: 3, title: "Final Column, Which Has a Long Long Title", value: "Value, which is Also a Long Long Value...")])
            Spacer()
        }
        .background(Color("theme1_charcoal"))
    }
}
