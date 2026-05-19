//
//  Movie.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import Foundation

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

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var formattedYear: String {
        guard let date = releaseDate, date.count >= 4 else { return "N/A" }
        return String(date.prefix(4))
    }

    var formattedRating: String {
        String(format: "%.1f", voteAverage)
    }
}
