//
//  MovieDTO.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath   = "poster_path"
        case releaseDate  = "release_date"
        case voteAverage  = "vote_average"
    }
}
