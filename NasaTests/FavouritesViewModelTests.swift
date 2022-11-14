//
//  FavouritesViewModelTests.swift
//  NasaTests
//
//  Created by Saurav Satpathy on 14/11/22.
//

import Foundation
import XCTest
@testable import Nasa

class FavouritesViewModelTests: XCTestCase {

    var favViewModel: FavouritePodManagable?

    override func setUpWithError() throws {
        favViewModel = MockFavouritesViewModel.init(favourites: [Favourites]())
    }

    override func tearDownWithError() throws {
        favViewModel = nil
    }

    func testGetAstronomyPods() throws {
        favViewModel?.getAstronomyPods(successful: { favs in
            XCTAssertNotNil(favs)
        }, failed: { message in
            XCTAssertNotNil(message)
        })
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

