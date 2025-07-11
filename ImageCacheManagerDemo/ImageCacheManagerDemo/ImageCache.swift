//
//  ImageCache.swift
//  ImageCacheManagerDemo
//
//  Created by Akshay Mamidwar    on 09/07/25.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        return memoryCache.object(forKey: key as NSString)
    }
    
    func insertImage(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
    }
    
    func removeImage(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
    }
    
    func removeAll() {
        memoryCache.removeAllObjects()
    }
}
