//
//  UIImageView+RemoteImage.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

extension UIImageView {
    /// Loads an image from either a Realtime Database avatar reference (`rtdb://avatars/<uid>`)
    /// or a plain URL string, falling back to `placeholder` when the source is missing/invalid
    /// or the request fails. No caching — intended for one-off avatar loads.
    func setImage(from source: String?, placeholder: UIImage?) {
        image = placeholder
        guard let source, !source.isEmpty else { return }

        if let uid = AvatarService.uid(fromReference: source) {
            AvatarService.shared.fetchAvatar(uid: uid) { [weak self] result in
                guard case .success(let data) = result,
                      let storedImage = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.image = storedImage
                }
            }
            return
        }

        guard let url = URL(string: source) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let downloadedImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = downloadedImage
            }
        }.resume()
    }
}
