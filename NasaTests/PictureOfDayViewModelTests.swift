//
//  PlanatoryPodManagableTests.swift
//  NasaTests
//
//  Created by Saurav Satpathy on 14/11/22.
//

import Foundation
import XCTest
@testable import Nasa

class PictureOfDayViewModelTests: XCTestCase {

    var podViewModel: PlanatoryPodManagable?
    override func setUpWithError() throws {
        podViewModel = MockPictureOfDayViewModel.init(pod: .init())
    }

    override func tearDownWithError() throws {
        podViewModel = nil
    }

    func testGetPictureOfDay() throws {
        podViewModel?.getPictureOfDay(date: "2022-01-11", successful: { pod in
            XCTAssertNotNil(pod)
        }, failed: { message in
            XCTAssertNotNil(message)
        })
    }
    
    func testUpdatePod() throws {
        let result = podViewModel?.updatePod(pod: PlanatoryPod())
        XCTAssertFalse(result ?? false)
    }
    
    func testRetrievePod() throws {
        let result = podViewModel?.retrievePod(date: "2021-03-02")
        XCTAssertNil(result)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
