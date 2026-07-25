//
//  StorageService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 25/07/2026.
//

import Foundation
import FirebaseStorage

final class StorageService {
    static let shared = StorageService()

    private let storage = Storage.storage()

    private init() {}

    // MARK: UPLOAD User Avatar
    func uploadAvatar(uid: String, imageData: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let reference = storage.reference().child("avatars/\(uid).jpg")
        reference.putData(imageData, metadata: metadata) { _, error in
            if let error {
                completion(.failure(error))
                return
            }

            reference.downloadURL { url, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                guard let url else {
                    completion(.failure(NSError(domain: "StorageService", code: -1)))
                    return
                }
                completion(.success(url))
            }
        }
    }
}
