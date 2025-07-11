//
//  ImageCell.swift
//  ImageCacheManagerDemo
//
//  Created by Akshay Mamidwar    on 09/07/25.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(red: 15/255, green: 25/255, blue: 55/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with url: URL) {
        print(url.absoluteString)
        ImageLoader.shared.loadImage(from: url) { [weak self] image in
            self?.imageView.image = image ?? UIImage(systemName: "photo")
        }
    }
}
