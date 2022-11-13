//
//  AstronomyPod.swift
//  Nasa
//
//  Created by Saurav Satpathy on 12/11/22.
//

import Foundation

struct PlanatoryPod: Codable {
    var copyright, date, explanation: String?
    var hdurl, thumbnail_url: String?
    var mediaType, serviceVersion, title: String?
    var url: String?
    var isFavourite: Bool?
}
