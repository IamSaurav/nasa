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
    private let cachedList = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(NSURL, UIImage?) -> Void]]()
    
    func image(url: NSURL) -> UIImage? {
        return cachedList.object(forKey: url)
    }
    
    func load(url: NSURL, completion: @escaping (NSURL, UIImage?) -> Void) {
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async { completion(url, cachedImage) }
            return
        }else if let storedImage = fetch(url: url) {
            self.cachedList.setObject(storedImage, forKey: url, cost: storedImage.pngData()!.count)
            DispatchQueue.main.async { completion(url, storedImage) }
            return
        }
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        // if not, download image from url
        FileDownloader.urlSession().dataTask(with: url as URL, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    self.cachedList.setObject(image, forKey: url, cost: data!.count)
                    self.store(image: image, url: url)
                    completion(url, image)
                }
            }
            
        }).resume()
        
    }
    
    @discardableResult
    func store(image: UIImage, url: NSURL) -> Bool  {
        let tempDir = FileManager.default.temporaryDirectory
        guard let fileName = url.lastPathComponent else {return false}
        let path = tempDir.appendingPathComponent(fileName)
        do {
            try image.pngData()?.write(to: path)
            return true
        } catch {
            return false
        }
    }
    
    func fetch(url: NSURL) -> UIImage?  {
        let tempDir = FileManager.default.temporaryDirectory
        guard let fileName = url.lastPathComponent else {return .none}
        let path = tempDir.appendingPathComponent(fileName)
        return UIImage.init(contentsOfFile: path.absoluteString)
    }
    
}

