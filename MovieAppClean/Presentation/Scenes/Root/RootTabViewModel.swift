//
//  RootTabViewModel.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import Combine

final class RootTabViewModel: RootTabViewModelProtocol {
    private var subscribers: Set<AnyCancellable> = []
    private let moviesDidTap = PassthroughSubject<Int, Never>()
    private let favouritesDidTap = PassthroughSubject<Int, Never>()

    let movieListVM: MovieListViewModel
    let favouriteListVM: FavouritesViewModel
    let moviesRouter: MovieRouter
    let favouritesRouter: MovieRouter

    init(fetchMoviesUseCase: FetchMoviesUseCaseProtocol,
         refreshMoviesUseCase: RefreshMoviesUseCaseProtocol,
         fetchFavouritesUseCase: FetchFavouritesUseCaseProtocol,
         movieDetailViewModelFactory: MovieDetailViewModelFactoryProtocol) {
        movieListVM = MovieListViewModel(
            fetchMoviesUseCase: fetchMoviesUseCase,
            refreshMoviesUseCase: refreshMoviesUseCase,
            didTapSubject: moviesDidTap
        )
        favouriteListVM = FavouritesViewModel(
            fetchFavouritesUseCase: fetchFavouritesUseCase,
            didTapSubject: favouritesDidTap
        )
        moviesRouter = MovieRouter(factory: movieDetailViewModelFactory)
        favouritesRouter = MovieRouter(factory: movieDetailViewModelFactory)

        bindTapSubjects()
    }

    private func bindTapSubjects() {
        moviesDidTap.sink { [weak self] movieId in
            self?.moviesRouter.navigate(to: .detail(movieId: movieId))
        }.store(in: &subscribers)

        favouritesDidTap.sink { [weak self] movieId in
            self?.favouritesRouter.navigate(to: .detail(movieId: movieId))
        }.store(in: &subscribers)
    }
}
