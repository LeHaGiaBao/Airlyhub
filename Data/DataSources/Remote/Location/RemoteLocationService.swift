//
//  RemoteLocationService.swift
//  Airlyhub
//
//  Created by Le Ha Gia Bao on 30/05/2026.
//  Copyright © 2026 airly. All rights reserved.
//

import Foundation

final class RemoteLocationService {
    static let shared = RemoteLocationService()

    private init() {}

    private var baseURL: String { AppEnvironment.current.locationSearchBaseURL }

    func search(query: String,
                completion: @escaping (Result<[LocationResult], Error>) -> Void) {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "addressdetails", value: "1"),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "accept-language", value: Locale.preferredLanguages.first ?? "en"),
        ]

        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        // Nominatim usage policy requires a valid User-Agent
        request.setValue("Airlyhub/1.0", forHTTPHeaderField: "User-Agent")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data else { return }
            do {
                let items = try JSONDecoder().decode([NominatimItem].self, from: data)
                let results = items.compactMap { $0.toLocationResult() }
                DispatchQueue.main.async { completion(.success(results)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}
