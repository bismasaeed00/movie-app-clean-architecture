//
//  RefreshMoviesUseCase.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

protocol RefreshMoviesUseCaseProtocol {
    func execute() async throws -> PaginatedMovies
}

final class RefreshMoviesUseCase: RefreshMoviesUseCaseProtocol {
    private let movieRepository: MovieRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }

    func execute() async throws -> PaginatedMovies {
        try await movieRepository.refreshMovies()
    }
}
