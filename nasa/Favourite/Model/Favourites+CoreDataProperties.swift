//
//  Favourites+CoreDataProperties.swift
//  Nasa
//
//  Created by Saurav Satpathy on 14/11/22.
//
//

import Foundation
import CoreData


extension Favourites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourites> {
        return NSFetchRequest<Favourites>(entityName: "Favourites")
    }

    @NSManaged public var copyright: String?
    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var isFavourite: Bool
    @NSManaged public var media_type: String?
    @NSManaged public var thumbnail_url: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var service_version: String?

}

extension Favourites : Identifiable {

    
}

extension Favourites {
    
    func toPlanatoryPod () -> PlanatoryPod {
        PlanatoryPod.init(copyright: self.copyright, date: self.date, explanation: self.explanation, hdurl: self.hdurl, thumbnail_url: self.thumbnail_url, media_type: self.media_type, service_version: self.service_version, title: self.title, url: self.url, isFavourite: self.isFavourite)
    }

}
