//
//  FavouritePodCell.swift
//  Nasa
//
//  Created by Saurav Satpathy on 13/11/22.
//

import Foundation
import UIKit

class FavouritePodCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    
    func populateData(pod: Favourites) {
        if pod.media_type == "video" {
            playImageView.isHidden = false
            downloadImage(urlString: pod.thumbnail_url)
        }else {
            playImageView.isHidden = true
            downloadImage(urlString: pod.url)
        }
    }
    
    func downloadImage(urlString: String?) {
        guard let urlStr = urlString, let url = URL.init(string: urlStr) else {return}
        ImageCache.shared.load(url: url as NSURL, completion: { _, image in
            self.imageView.image = image
        })
    }
    
}
