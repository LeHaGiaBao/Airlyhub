//
//  UIImageView+RemoteImage.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

extension UIImageView {
    /// Loads an image from a URL string, falling back to `placeholder` when the URL is
    /// missing/invalid or the request fails. No caching — intended for one-off avatar loads.
    func setImage(from urlString: String?, placeholder: UIImage?) {
        image = placeholder
        guard let urlString, let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let downloadedImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = downloadedImage
            }
        }.resume()
    }
}
