//  UIImageViewExtensions.swift
//  Created by Victor Magalhaes
//  Copyright © 2019 Victor. All rights reserved.


import UIKit
import Foundation

fileprivate let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {

    public func loadImage(from urlString: String, placeHolder: UIImage? = nil) {
        image = nil
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, _, _) in
            let image: UIImage? = {
                guard let data = data, let downloadedImage = UIImage(data: data) else { return placeHolder }
                imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                return downloadedImage
            }()

            DispatchQueue.main.async { self?.image = image }
            
        }).resume()
    }
}
