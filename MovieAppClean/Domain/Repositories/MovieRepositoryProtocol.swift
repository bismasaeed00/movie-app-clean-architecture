//
//  MovieRepositoryProtocol.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

protocol MovieRepositoryProtocol {
    func fetchMovies(page: Int) async throws -> PaginatedMovies
    func refreshMovies() async throws -> PaginatedMovies
    func fetchMovieDetail(movieId: Int) async throws -> Movie

    @MainActor func cachedMovies() -> [Movie]
    @MainActor func cachedMovie(movieId: Int) -> Movie?
}
