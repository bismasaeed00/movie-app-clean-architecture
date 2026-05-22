//
//  ViewModelFactory.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

protocol MovieDetailViewModelFactoryProtocol {
    @MainActor func makeMovieDetailViewModel(movieId: Int) -> MovieDetailViewModel?
}

final class MovieDetailViewModelFactory: MovieDetailViewModelFactoryProtocol {
    private let movieRepository: MovieRepositoryProtocol
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol
    private let toggleFavouriteUseCase: ToggleFavouriteUseCaseProtocol

    init(movieRepository: MovieRepositoryProtocol,
         fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol,
         toggleFavouriteUseCase: ToggleFavouriteUseCaseProtocol) {
        self.movieRepository = movieRepository
        self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
        self.toggleFavouriteUseCase = toggleFavouriteUseCase
    }

    @MainActor
    func makeMovieDetailViewModel(movieId: Int) -> MovieDetailViewModel? {
        guard let movie = movieRepository.cachedMovie(movieId: movieId) else { return nil }
        return MovieDetailViewModel(
            movie: movie,
            fetchMovieDetailUseCase: fetchMovieDetailUseCase,
            toggleFavouriteUseCase: toggleFavouriteUseCase
        )
    }
}
