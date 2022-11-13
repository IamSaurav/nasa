//
//  ImageCache.swift
//  Nasa
//
//  Created by Saurav Satpathy on 12/11/22.
//

import Foundation
import UIKit

final class ImageCache {
    
    public static let shared = ImageCache()
    var placeholderImage = UIImage(systemName: "rectangle")!
    private let cachedList = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(NSURL, UIImage?) -> Void]]()
    
    func image(url: NSURL) -> UIImage? {
        return cachedList.object(forKey: url)
    }
    
    func load(url: NSURL, completion: @escaping (NSURL, UIImage?) -> Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(url, cachedImage)
            }
            return
        }
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        // if not, download image from url
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }

                    DispatchQueue.main.async {
                        if let image = UIImage(data: data!) {
                            self.cachedList.setObject(image, forKey: url, cost: data!.count)
                            completion(url, image)
                        }
                    }

                }).resume()
        
//        FileDownloader.urlSession().dataTask(with: url as URL) { (data, response, error) in
//            guard let responseData = data, let image = UIImage(data: responseData),
//                  let blocks = self.loadingResponses[url], error == nil else {
//                      DispatchQueue.main.async {
//                          completion(url, nil)
//                      }
//                      return
//                  }
//            self.cachedList.setObject(image, forKey: url, cost: responseData.count)
//            for block in blocks {
//                DispatchQueue.main.async {
//                    block(url, image)
//                }
//                return
//            }
//        }.resume()
    }

//
//    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
//        ImageDownloader.urlSession().dataTask(with: url) { (data, response, error) in
//            guard let responseData = data, let image = UIImage(data: responseData),
//                  let blocks = self.loadingResponses[url], error == nil else {
//                      DispatchQueue.main.async { completion(item, nil) }
//                      return
//                  }
//            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
//            for block in blocks {
//                DispatchQueue.main.async {
//                    block(item, image)
//                }
//                return
//            }
//        }.resume()
//    }
    
    
}
