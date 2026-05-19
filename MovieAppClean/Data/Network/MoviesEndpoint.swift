//
//  MoviesEndpoint.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import Foundation

enum MovieEndpoint {
    case discoverMovies(page: Int)
    case movieDetail(id: Int)

    private static let baseURL = "https://api.themoviedb.org/3"

    var urlString: String {
        switch self {
        case .discoverMovies:
            return "\(Self.baseURL)/discover/movie"
        case .movieDetail(let id):
            return "\(Self.baseURL)/movie/\(id)"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .discoverMovies(let page):
            return [
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
                URLQueryItem(name: "include_adult", value: "false"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .movieDetail:
            return [
                URLQueryItem(name: "language", value: "en-US")
            ]
        }
    }
}
