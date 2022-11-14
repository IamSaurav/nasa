//
//  FavouritesViewModel.swift
//  Nasa
//
//  Created by Saurav Satpathy on 12/11/22.
//

import Foundation
import UIKit

protocol FavouritePodManagable {
    func getAstronomyPods(successful: @escaping (([Favourites])->Void), failed: @escaping ((String)->Void))
    var astronomyPods: [Favourites] {get set}
}

class FavouritesViewModel: FavouritePodManagable {
    
    var astronomyPods = [Favourites]()
    
    func getAstronomyPods(successful: @escaping (([Favourites])->Void), failed: @escaping ((String)->Void)) {
        let databaseManager = DatabaseManager()
        if let pods = databaseManager.fetchPlanatoryPods() {
            astronomyPods = pods
            successful(pods)
            return
        }
            
    }
    
    
    
    
    
}
