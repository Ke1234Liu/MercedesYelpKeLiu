//
//  ExpandCollapseButton.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/26/23.
//

import SwiftUI

struct ExpandCollapseButton: View {
    
    let isExpanded: Bool
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Button {
                action()
            } label: {
                ZStack {
                    Image(systemName: "minus")
                        .opacity(isExpanded ? 1.0 : 0.0)
                    Image(systemName: "plus")
                        .opacity(isExpanded ? 0.0 : 1.0)
                    
                }
                .font(.system(size: 28.0).bold())
                .foregroundColor(Color("theme1_saffron"))
                .frame(width: 36.0, height: 36.0)
                .box(backgroundColor: Color("theme1_charcoal"),
                     strokeColor: Color("theme1_saffron"),
                     cornerRadius: 8.0,
                     strokeWidth: Device.isIpad ? 3.0 : 2.0)
                
            }
        }
        .frame(width: 44.0, height: 44.0)
    }
}

struct ExpandCollapseButton_Previews: PreviewProvider {
    static var previews: some View {
        ExpandCollapseButton(isExpanded: true) { }
    }
}
