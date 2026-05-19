//
//  RootTabViewModel.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import Combine

final class RootTabViewModel: RootTabViewModelProtocol {
    private var subscribers: Set<AnyCancellable> = []
    private let didTapSubject = PassthroughSubject<Int, Never>()

    let movieListVM: MovieListViewModel
    let favouriteListVM: FavouritesViewModel
    let movieRouter: MovieRouter

    init(movieRepository: MovieRepositoryProtocol, favouriteRepository: FavouriteRepositoryProtocol) {
        movieListVM = MovieListViewModel(movieRepository: movieRepository, didTapSubject: didTapSubject)
        favouriteListVM = FavouritesViewModel(favouriteRepository: favouriteRepository, didTapSubject: didTapSubject)
        movieRouter = MovieRouter(movieRepository: movieRepository, favouriteRepository: favouriteRepository)

        bindTapSubject()
    }

    private func bindTapSubject() {
        didTapSubject.sink { [weak self] movieId in
            guard let self else { return }
            movieRouter.navigate(to: .detail(movieId: movieId))
        }.store(in: &subscribers)
    }
}
