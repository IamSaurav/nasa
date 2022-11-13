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
    func updateFavouriteStatus(pod: PlanatoryPod)
    var plantoryPod: PlanatoryPod {get set}
}

class PlanatoryPodViewModel: PlanatoryPodManagable {
    
    var plantoryPod = PlanatoryPod()
    
    func getPictureOfDay(date: String, successful: @escaping ((PlanatoryPod)->Void), failed: @escaping ((String)->Void)) {
        ApiManager().sendPodRequest(date: date) { (result: Result<PlanatoryPod, NasaError>) in
            switch result {
            case .success(let pod):
                self.plantoryPod = pod
                DispatchQueue.main.async { successful(self.plantoryPod) }
            case .failure(let message):
                failed(message.localizedDescription)
            }
        }
    }
    
    func updateFavouriteStatus(pod: PlanatoryPod) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        guard let favouitesEntity = NSEntityDescription.entity(forEntityName: "Favouites", in: context) else { return }
        let managedObject = NSManagedObject.init(entity: favouitesEntity, insertInto: context)
        managedObject.setValue(pod.date, forKey: "date")
        managedObject.setValue(pod.date, forKey: "copyright")
        managedObject.setValue(pod.date, forKey: "explanation")
        managedObject.setValue(pod.date, forKey: "thumbnail_url")
        managedObject.setValue(pod.date, forKey: "mediaType")
        managedObject.setValue(pod.date, forKey: "title")
        managedObject.setValue(pod.date, forKey: "url")
        managedObject.setValue(pod.isFavourite, forKey: "isFavourite")
        do {
            try context.save()
        }catch(let _) {
            
        }
    }
    
    func retrieveFavouriteStatus(pod: PlanatoryPod) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Favouites")
        do {
            let result = try context.fetch(fetchRequest)
            guard result.count > 0, let results = result as? [NSManagedObject] else {return}
            let managedObject = results[0]
            managedObject.value(forKey: "date")
            managedObject.value(forKey: "copyright")
            managedObject.value(forKey: "explanation")
            managedObject.value(forKey: "title")
            managedObject.value(forKey: "url")
            managedObject.value(forKey: "isFavourite")
        }catch(let _) {
            
        }
        guard let favouitesEntity = NSEntityDescription.entity(forEntityName: "Favouites", in: context) else { return }
        let managedObject = NSManagedObject.init(entity: favouitesEntity, insertInto: context)
        managedObject.setValue(pod.date, forKey: "date")
        managedObject.setValue(pod.date, forKey: "copyright")
        managedObject.setValue(pod.date, forKey: "explanation")
        managedObject.setValue(pod.date, forKey: "thumbnail_url")
        managedObject.setValue(pod.date, forKey: "mediaType")
        managedObject.setValue(pod.date, forKey: "title")
        managedObject.setValue(pod.date, forKey: "url")
        managedObject.setValue(pod.isFavourite, forKey: "isFavourite")
        do {
            try context.save()
        }catch(let _) {
            
        }
    }
    
    
}
