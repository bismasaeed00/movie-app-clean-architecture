//
//  FetchMoviesUseCase.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

protocol FetchMoviesUseCaseProtocol {
    func execute(page: Int) async throws -> PaginatedMovies
}

final class FetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    private let movieRepository: MovieRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }

    func execute(page: Int) async throws -> PaginatedMovies {
        try await movieRepository.fetchMovies(page: page)
    }
}
