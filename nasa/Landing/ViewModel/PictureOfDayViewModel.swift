//
//  PictureOfDayManager.swift
//  Nasa
//
//  Created by Saurav Satpathy on 12/11/22.
//

import Foundation
import UIKit
import CoreData

protocol PlanatoryPodManagable {
    func getPictureOfDay(date: String, successful: @escaping ((PlanatoryPod)->Void), failed: @escaping ((String)->Void))
    func updatePod(pod: PlanatoryPod) -> Bool
    func retrievePod(date: String) -> PlanatoryPod?
    var plantoryPod: PlanatoryPod {get set}
}

class PlanatoryPodViewModel: PlanatoryPodManagable {
    
    var plantoryPod = PlanatoryPod()
    var databaseManager = DatabaseManager()
    
    func getPictureOfDay(date: String, successful: @escaping ((PlanatoryPod)->Void), failed: @escaping ((String)->Void)) {
        if let pod = retrievePod(date: date) {
            self.plantoryPod = pod
            successful(pod)
            return
        }
        ApiManager().sendPodRequest(date: date) { (result: Result<PlanatoryPod, NasaError>) in
            switch result {
            case .success(let pod):
                self.plantoryPod = pod
                DispatchQueue.main.async { successful(self.plantoryPod) }
            case .failure(let message):
                DispatchQueue.main.async { failed(message.localizedDescription) }
            }
        }
    }
    
    @discardableResult
    func updatePod(pod: PlanatoryPod) -> Bool {
        databaseManager.store(pod: pod)
    }
    
    func retrievePod(date: String) -> PlanatoryPod? {
        databaseManager.fetchPlanatoryPods(date: date)?.toPlanatoryPod()
    }
    
    
}
