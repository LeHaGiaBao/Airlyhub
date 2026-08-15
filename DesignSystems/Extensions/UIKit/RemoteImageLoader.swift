//
//  RemoteImageLoader.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 15/08/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import UIKit

/// Caching image loader for lists.
///
/// `UIImageView.setImage(from:placeholder:)` is fine for the one-off avatar it was
/// written for, but a scrolling list needs two things it does not do:
///
/// - **Caching.** Without it every cell reuse re-downloads artwork the user just
///   scrolled past, which on a metered connection is the same photo fetched a dozen
///   times in a minute.
/// - **Cancellation.** A recycled image view has a request still in flight for the
///   row it used to show. Whichever response lands last wins, so a slow image can
///   drop into a cell that now displays something else entirely.
///
/// Both are handled by tagging each image view with the URL it currently wants and
/// discarding any response that no longer matches.
final class RemoteImageLoader {
    static let shared = RemoteImageLoader()

    /// Decoded images, evicted automatically under memory pressure.
    ///
    /// Counted in bytes rather than entries so one very large photo cannot push out
    /// twenty small ones — `totalCostLimit` is meaningless unless the cost is a size.
    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.totalCostLimit = 64 * 1024 * 1024
        return cache
    }()

    private init() {}

    func cachedImage(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    /// - Parameter completion: called on the main queue, and only on success.
    ///   A failure leaves whatever placeholder the caller set in place.
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

// MARK: - UIImageView
private var imageRequestKey: UInt8 = 0

extension UIImageView {
    /// URL this image view is currently waiting on. Stored on the view itself so a
    /// response can check whether it is still wanted before assigning.
    private var pendingImageURL: URL? {
        get { objc_getAssociatedObject(self, &imageRequestKey) as? URL }
        set { objc_setAssociatedObject(self, &imageRequestKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Loads artwork from a plain web URL, cached and safe to call from a reused cell.
    ///
    /// Use this for catalog images. `setImage(from:placeholder:)` remains the right
    /// call for avatars, which may be Realtime Database references rather than URLs.
    func setCachedImage(from source: String?, placeholder: UIImage?) {
        guard let source, let url = URL(string: source) else {
            pendingImageURL = nil
            image = placeholder
            return
        }

        // A cache hit assigns synchronously, which matters during scrolling: going
        // through the placeholder first would flicker on every reuse.
        if let cached = RemoteImageLoader.shared.cachedImage(for: url) {
            pendingImageURL = nil
            image = cached
            return
        }

        pendingImageURL = url
        image = placeholder

        RemoteImageLoader.shared.load(url) { [weak self] image in
            // The view may have been recycled while this was in flight; the tag is
            // what tells us the response belongs to somebody else now.
            guard let self, self.pendingImageURL == url else { return }
            self.pendingImageURL = nil
            self.image = image
        }
    }
}
