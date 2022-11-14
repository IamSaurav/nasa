//
//  DatabaseManager.swift
//  Nasa
//
//  Created by Saurav Satpathy on 14/11/22.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    let favouitesEntity = "Favourites"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func fetchPlanatoryPods() -> [Favourites]? {
        let context = appDelegate.persistentContainer.viewContext
        do {
            let results = try context.fetch(Favourites.fetchRequest())
            return results
        }catch {
            return .none
        }
    }
    
    func fetchPlanatoryPods(date: String) -> Favourites? {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Favourites.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        do {
            let results = try context.fetch(fetchRequest)
            guard let podManagedObj = results.first else {return .none}
            return podManagedObj
        }catch {
            return .none
        }
    }

    func store(pod: PlanatoryPod) -> Bool {
        guard let date = pod.date else {return false}
        let context = appDelegate.persistentContainer.viewContext
        guard let favouitesEntity = NSEntityDescription.entity(forEntityName: "Favourites", in: context) else { return false }
        var podManagedObject = fetchPlanatoryPods(date: date)
        podManagedObject = podManagedObject == nil ? Favourites(entity: favouitesEntity, insertInto: context) : podManagedObject
        podManagedObject?.date = pod.date
        podManagedObject?.copyright = pod.copyright
        podManagedObject?.explanation = pod.explanation
        podManagedObject?.thumbnail_url = pod.thumbnail_url
        podManagedObject?.media_type = pod.media_type
        podManagedObject?.title = pod.title
        podManagedObject?.url = pod.url
        podManagedObject?.isFavourite = pod.isFavourite == true
        appDelegate.saveContext()
        return true
    }
    
}
