//
//  MockPictureOfDayViewModel.swift
//  NasaTests
//
//  Created by Saurav Satpathy on 14/11/22.
//

import Foundation
import XCTest
@testable import Nasa

internal class MockPictureOfDayViewModel: PlanatoryPodManagable {

    var plantoryPod = PlanatoryPod()

    init(pod: PlanatoryPod) {
        plantoryPod = pod
    }

    func getPictureOfDay(date: String, successful: @escaping ((PlanatoryPod)->Void), failed: @escaping ((String)->Void)) {
        if Bool.random() {
            successful(PlanatoryPod())
        }else{
            failed("Failed to load")
        }
    }
    
    func updatePod(pod: PlanatoryPod) -> Bool {
        return false
    }
    
    func retrievePod(date: String) -> PlanatoryPod? {
        return .none
    }
    
}

