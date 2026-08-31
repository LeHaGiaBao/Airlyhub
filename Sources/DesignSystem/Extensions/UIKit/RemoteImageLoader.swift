//
//  RemoteImageLoader.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Caching image loader for lists.
final class RemoteImageLoader {
    static let shared = RemoteImageLoader()

    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.totalCostLimit = 64 * 1024 * 1024
        return cache
    }()

    private init() {}

    func cachedImage(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    @discardableResult
    func load(_ url: URL, completion: @escaping (UIImage) -> Void) -> URLSessionDataTask? {
        if let cached = cachedImage(for: url) {
            completion(cached)
            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            self?.cache.setObject(image, forKey: url as NSURL, cost: data.count)
            DispatchQueue.main.async { completion(image) }
        }
        task.resume()
        return task
    }
}

private var imageRequestKey: UInt8 = 0

extension UIImageView {
    private var pendingImageURL: URL? {
        get { objc_getAssociatedObject(self, &imageRequestKey) as? URL }
        set { objc_setAssociatedObject(self, &imageRequestKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setCachedImage(from source: String?, placeholder: UIImage?) {
        guard let source, let url = URL(string: source) else {
            pendingImageURL = nil
            image = placeholder
            return
        }

        if let cached = RemoteImageLoader.shared.cachedImage(for: url) {
            pendingImageURL = nil
            image = cached
            return
        }

        pendingImageURL = url
        image = placeholder

        RemoteImageLoader.shared.load(url) { [weak self] image in
            guard let self, self.pendingImageURL == url else { return }
            self.pendingImageURL = nil
            self.image = image
        }
    }
}
