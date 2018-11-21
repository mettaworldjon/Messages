//
//  ImageCache.swift
//  Messages
//
//  Created by Jonathan on 11/12/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()


extension UIImageView {
    
    func loadImageUsingCahceWithURLString(_ urlString: String) {
        self.image = nil
        
        // Check If Cache Exist
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // Download Image
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            
            // Error Check
            if let error = err {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadImage = UIImage(data: data!) {
                    imageCache.setObject(downloadImage, forKey: urlString as NSString)
                    self.image = downloadImage
                }
            }
        }.resume()
    }
    
}
