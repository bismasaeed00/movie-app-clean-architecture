//
//  MovieListResponseDTO.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

struct MovieListResponseDTO: Codable {
    let results: [MovieDTO]
    let page: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}
