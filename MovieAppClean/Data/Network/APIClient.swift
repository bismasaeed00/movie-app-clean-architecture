//
//  APIClient.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case httpError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP error \(code)."
        }
    }
}

final class APIClient {
    private let apiKey = "3db0f53e603350e7a4fda7a09419f20a"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: MovieEndpoint) async throws -> T {
        var components = URLComponents(string: endpoint.urlString)
        var queryItems = endpoint.queryItems
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw APIError.networkError(error)
        }

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.httpError(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
