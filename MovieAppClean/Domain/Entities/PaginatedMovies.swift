//
//  PaginatedMovies.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

struct PaginatedMovies {
    let movies: [Movie]
    let currentPage: Int
    let totalPages: Int

    var hasMorePages: Bool {
        currentPage < totalPages
    }
}
