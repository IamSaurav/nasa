//
//  PodManagedObject.swift
//  Nasa
//
//  Created by Saurav Satpathy on 14/11/22.
//

import Foundation
import CoreData

public class Favourites: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favouites> {
            return NSFetchRequest<Favouites>(entityName: "Favouites")
    }
    
    @NSManaged var copyright, date, explanation: String?
    @NSManaged var hdurl, thumbnail_url: String?
    @NSManaged var mediaType, serviceVersion, title: String?
    @NSManaged var url: String?
    @NSManaged var isFavourite: Bool?
    
}

extension Favourites {
    
    func toPlanatoryPod () -> PlanatoryPod {
        PlanatoryPod.init(copyright: self.copyright, date: self.date, explanation: self.explanation, hdurl: self.hdurl, thumbnail_url: self.thumbnail_url, mediaType: self.mediaType, serviceVersion: self.serviceVersion, title: self.serviceVersion, url: self.url, isFavourite: false)
    }

}

