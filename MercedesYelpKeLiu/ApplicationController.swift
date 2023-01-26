//
//  ApplicationController.swift
//  MercedesYelpKeLiu
//
//  Created by Ke Liu on 1/25/23.
//

import Foundation

class ApplicationController {
    
    static let defaultLat = 33.83422265228964
    static let defaultLon = -118.21241904417631
    
    let network = NetworkManager()
    
    static func mock() -> ApplicationController {
        ApplicationController()
    }
    
    lazy var viewModel: ViewModel = {
        ViewModel(app: self)
    }()
    
}
