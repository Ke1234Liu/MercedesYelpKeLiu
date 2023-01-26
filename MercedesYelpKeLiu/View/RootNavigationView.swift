//
//  RootNavigationView.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import Foundation
import SwiftUI

struct RootNavigationView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            RestaurantsView(viewModel: viewModel)
        }
    }
}
