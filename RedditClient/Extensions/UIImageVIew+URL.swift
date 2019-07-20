//
//  UIImageVIew+URL.swift
//  RedditClient
//
//  Created by Santiago B on 20/07/2019.
//  Copyright © 2019 Inosur. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func fetch(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
    func setImage(from stringURL: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: stringURL) else { return }
        fetch(from: url, contentMode: mode)
    }
}
