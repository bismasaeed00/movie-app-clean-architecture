//
//  DependencyManager.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

final class DependencyManager {
    static let shared = DependencyManager()

    private let coreDataStack: CoreDataStack
    private let apiClient: APIClient
    private let movieRepository: MovieRepositoryProtocol
    private let favouriteRepository: FavouriteRepositoryProtocol

    let fetchMoviesUseCase: FetchMoviesUseCaseProtocol
    let refreshMoviesUseCase: RefreshMoviesUseCaseProtocol
    let fetchFavouritesUseCase: FetchFavouritesUseCaseProtocol
    let movieDetailViewModelFactory: MovieDetailViewModelFactoryProtocol

    private init() {
        coreDataStack = CoreDataStack()
        apiClient = APIClient()
        movieRepository = MovieRepository(apiClient: apiClient, coreDataStack: coreDataStack)
        favouriteRepository = FavouriteRepository(coreDataStack: coreDataStack)

        fetchMoviesUseCase = FetchMoviesUseCase(movieRepository: movieRepository)
        refreshMoviesUseCase = RefreshMoviesUseCase(movieRepository: movieRepository)
        fetchFavouritesUseCase = FetchFavouritesUseCase(favouriteRepository: favouriteRepository)

        let fetchMovieDetailUseCase = FetchMovieDetailUseCase(movieRepository: movieRepository)
        let toggleFavouriteUseCase = ToggleFavouriteUseCase(favouriteRepository: favouriteRepository)

        movieDetailViewModelFactory = MovieDetailViewModelFactory(
            movieRepository: movieRepository,
            fetchMovieDetailUseCase: fetchMovieDetailUseCase,
            toggleFavouriteUseCase: toggleFavouriteUseCase
        )
    }
}
