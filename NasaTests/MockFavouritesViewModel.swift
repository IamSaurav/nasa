//
//  MockFavouritesViewModel.swift
//  NasaTests
//
//  Created by Saurav Satpathy on 14/11/22.
//

import Foundation
import XCTest
@testable import Nasa

internal class MockFavouritesViewModel: FavouritePodManagable {

    var astronomyPods: [Favourites]
    
    init(favourites: [Favourites]) {
        astronomyPods = favourites
    }

    func getAstronomyPods(successful: @escaping (([Favourites])->Void), failed: @escaping ((String)->Void)) {
        if Bool.random() {
            successful([Favourites]())
        }else{
            failed("Failed to load")
        }
    }

    
}

