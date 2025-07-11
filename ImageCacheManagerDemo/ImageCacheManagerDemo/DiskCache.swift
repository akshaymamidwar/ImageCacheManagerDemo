//
//  DiskCache.swift
//  ImageCacheManagerDemo
//
//  Created by Akshay Mamidwar    on 09/07/25.
//

import Foundation
import UIKit
import CommonCrypto

// MARK: - String MD5 extension for hashing cache keys

extension String {
    func md5() -> String {
        let data = Data(self.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_MD5($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - File metadata struct

struct FileMetadata {
    let size: UInt64
    let lastAccessDate: Date
}

// MARK: - DiskCache class

class DiskCache {
    private var cacheIndex: [String: FileMetadata] = [:]  // hashedKey -> metadata
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let ioQueue = DispatchQueue(label: "DiskCache.ioQueue")
    
    init(cacheFolderName: String = "CustomImageDiskCache") {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = caches.appendingPathComponent(cacheFolderName)
        createCacheDirectory()
        buildIndex()
    }
    
    private func createCacheDirectory() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            } catch {
                print("Failed to create cache directory: \(error)")
            }
        }
    }
    
    private func buildIndex() {
        ioQueue.async {
            var index = [String: FileMetadata]()
            do {
                let files = try self.fileManager.contentsOfDirectory(atPath: self.cacheDirectory.path)
                for file in files {
                    let fileURL = self.cacheDirectory.appendingPathComponent(file)
                    if let attrs = try? self.fileManager.attributesOfItem(atPath: fileURL.path),
                       let size = attrs[.size] as? UInt64,
                       let date = attrs[.creationDate] as? Date {
                        index[file] = FileMetadata(size: size, lastAccessDate: date)
                    }
                }
            } catch {
                print("Failed to read cache directory contents: \(error)")
            }
            DispatchQueue.main.async {
                self.cacheIndex = index
            }
        }
    }
    
    //    func hasImage(forKey key: String) -> Bool {
    //        let hashedKey = key.md5()
    //        return cacheIndex[hashedKey] != nil
    //    }
    
    func saveImageData(_ data: Data, forKey key: String) {
        let hashedKey = key.md5()
        let fileURL = cacheDirectory.appendingPathComponent(hashedKey)
        ioQueue.async {
            do {
                try data.write(to: fileURL)
                let attrs = try self.fileManager.attributesOfItem(atPath: fileURL.path)
                if let size = attrs[.size] as? UInt64,
                   let date = attrs[.creationDate] as? Date {
                    let metadata = FileMetadata(size: size, lastAccessDate: date)
                    DispatchQueue.main.async {
                        self.cacheIndex[hashedKey] = metadata
                    }
                }
            } catch {
                print("Failed to write image data to disk: \(error)")
            }
        }
    }
    
    func loadImage(forKey key: String, completion: @escaping (UIImage?) -> Void) {
        let hashedKey = key.md5()
        guard cacheIndex[hashedKey] != nil else {
            DispatchQueue.main.async { completion(nil) }
            return
        }
        let fileURL = cacheDirectory.appendingPathComponent(hashedKey)
        ioQueue.async {
            if let data = try? Data(contentsOf: fileURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

