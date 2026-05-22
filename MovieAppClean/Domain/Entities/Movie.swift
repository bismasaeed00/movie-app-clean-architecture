//
//  Movie.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

struct Movie: Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    var isFavourite: Bool
    var genres: [Genre]
    var runtime: Int?
}
