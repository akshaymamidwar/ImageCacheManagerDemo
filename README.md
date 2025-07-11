
# 🖼️ ImageCacheManagerDemo

A simple demo app built using UIKit that loads and displays 500 remote images in a `UICollectionView`, with an efficient **multi-level caching mechanism**:
- 🔄 In-Memory Cache using `NSCache`
- 💾 Disk Cache using hashed keys (MD5)
- 🌐 Fallback to Network if not cached

## 🚀 Features

- Lazy image loading with fallback logic:  
  `Memory Cache → Disk Cache → Network`
- Disk caching with file indexing and metadata
- Smooth scrolling through 500 image cells
- Reusable `ImageLoader` and `DiskCache` components
- Scalable architecture, easily extensible for real apps

## 🛠️ Architecture Overview

```
ViewController
 └── UICollectionView with 500 image URLs
     └── ImageCell
         └── ImageLoader.shared.loadImage()
              ├── Memory Cache (NSCache)
              ├── Disk Cache (stored as hashed files)
              └── Network download (if needed)
```

## 📁 Caching Strategy

### 1. ✅ In-Memory Cache (`ImageCache.swift`)
- Uses `NSCache` to quickly serve already-loaded `UIImage`s.

### 2. ✅ Disk Cache (`DiskCache.swift`)
- Persists image data using file system.
- Uses MD5 hash of URL as the file key.
- Asynchronously loads and writes to disk.
- Keeps track of metadata (size, last accessed).

### 3. 🌐 Network Fallback
- Downloads from URL only if not in memory or disk.
- Saves result back to memory and disk for next time.

## 🧩 Components

| File               | Responsibility                                  |
|--------------------|--------------------------------------------------|
| `ViewController.swift` | Hosts `UICollectionView` and image grid     |
| `ImageCell.swift`      | Displays individual image using `ImageLoader` |
| `ImageLoader.swift`    | Coordinates cache layers and fetch strategy |
| `ImageCache.swift`     | Wraps `NSCache` for memory-level caching    |
| `DiskCache.swift`      | Manages file I/O and cache indexing         |

## 📸 Screenshots
![Simulator Screen Recording - iPhone 16 - 2025-07-11 at 15 34 55](https://github.com/user-attachments/assets/b022b590-9d9b-41ad-b8aa-ca471c168a6d)



## 🧪 How to Run

1. Clone this repo
2. Open `ImageCacheManagerDemo.xcodeproj`
3. Build and run on iOS Simulator (target: iOS 15+ recommended)

No third-party libraries or dependencies required.

## 📦 Requirements

- Xcode 13 or newer
- iOS 16+
- Swift 5+

## 🔐 License

This project is open-source and free to use. Feel free to fork, contribute, or improve.

---

## 🙌 Credits

Created by **Akshay Mamidwar**  
If you found this useful, feel free to ⭐️ the repo!
