//
//  ImageLoader.swift
//  ImageCacheManagerDemo
//
//  Created by Akshay Mamidwar    on 09/07/25.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    private let memoryCache = ImageCache.shared
    private let diskCache = DiskCache()
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString
        // 1. Check memory cache
        if let cachedImage = memoryCache.image(forKey: key) {
            print("Loaded from memory cache")
            completion(cachedImage)
            return
        }
        
        // 2. Check disk cache
        diskCache.loadImage(forKey: key) { [weak self] image in
            if let image = image {
                print("Loaded from disk cache")
                // Save to memory cache for next time
                self?.memoryCache.insertImage(image, forKey: key)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                // 3. Download from network
                self?.downloadImage(url: url, key: key, completion: completion)
            }
        }
    }
    
    private func downloadImage(url: URL, key: String, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // Save to memory cache
            self.memoryCache.insertImage(image, forKey: key)
            // Save to disk cache
            self.diskCache.saveImageData(data, forKey: key)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
