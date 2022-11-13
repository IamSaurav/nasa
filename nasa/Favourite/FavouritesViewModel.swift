//
//  FavouritesViewModel.swift
//  Nasa
//
//  Created by Saurav Satpathy on 12/11/22.
//

import Foundation
import UIKit

protocol FavouritePodManagable {
    func getAstronomyPods(successful: @escaping (([PlanatoryPod])->Void), failed: @escaping ((String)->Void))
    var astronomyPods: [PlanatoryPod] {get set}
}

class FavouritesViewModel: FavouritePodManagable {
    
    var astronomyPods = [PlanatoryPod]()
    
    func getAstronomyPods(successful: @escaping (([PlanatoryPod])->Void), failed: @escaping ((String)->Void)) {
        let p1 = PlanatoryPod.init(copyright: "", date: "2022-01-25", explanation: "Which direction is this comet heading?  Judging by the tail, one might imagine that Comet Leonard is traveling towards the bottom right, but a full 3D analysis shows it traveling almost directly away from the camera.  With this perspective, the dust tail is trailed towards the camera", thumbnail_url: "https://img.youtube.com/vi/s6IpsM_HNcU/0.jpg", mediaType: "video", serviceVersion: "1.2", title: "Video: Comet Leonard over One Hour", url: "https://www.youtube.com/embed/s6IpsM_HNcU?rel=0", isFavourite: true)
        
        let p2 = PlanatoryPod.init(copyright: "", date: "2022-01-27", explanation: "South of the large star-forming region known as the Orion Nebula, lies bright blue reflection nebula NGC 1999. At the edge of the Orion molecular cloud complex some 1,500 light-years distant, NGC 1999's illumination is provided by the embedded variable star V380 Orionis. The nebula is marked with a dark sideways T-shape at center right in this telescopic vista that spans about two full moons on the sky. Its dark shape was once assumed to be an obscuring dust cloud seen in silhouette. But infrared data suggest the shape is likely a hole blown through the nebula itself by energetic young stars. In fact, this region abounds with energetic young stars producing jets and", hdurl: "https://apod.nasa.gov/apod/image/2201/NGC-1999_1100.jpg", mediaType: "image", serviceVersion: "1.2", title: "South of Orion", url: "https://apod.nasa.gov/apod/image/2201/NGC-1999_1100.jpg", isFavourite: true)
        
        let p3 = PlanatoryPod.init(copyright: "", date: "2022-01-27", explanation: "This Navcam mosaic from Perseverance looks out over the car-sized rover's deck, across the floor of Jezero crater on Mars. Frames used to construct the mosaic view were captured on mission sol 354. That corresponds to Earth c", hdurl: "https://apod.nasa.gov/apod/image/2201/NGC-1999_1100.jpg", mediaType: "image", serviceVersion: "1.2", title: "Perseverance Sol 354", url: "https://apod.nasa.gov/apod/image/2202/PerseveranceSol354Nav1_1br2_KenKremer1024.jpg", isFavourite: true)
        astronomyPods = [p1, p2, p3]
        
        successful(astronomyPods)
    }
    
    
    
    
    
}
