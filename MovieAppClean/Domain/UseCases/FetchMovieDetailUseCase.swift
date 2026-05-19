//
//  FetchMovieDetailUseCase.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

protocol FetchMovieDetailUseCaseProtocol {
    func execute(movieId: Int) async throws -> Movie
}

final class FetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol {
    private let movieRepository: MovieRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }

    func execute(movieId: Int) async throws -> Movie {
        try await movieRepository.fetchMovieDetail(movieId: movieId)
    }
}
