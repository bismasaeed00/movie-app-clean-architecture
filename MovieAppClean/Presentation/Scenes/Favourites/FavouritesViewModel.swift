//
//  FavouritesViewModel.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import Combine

@MainActor
final class FavouritesViewModel: FavouritesViewModelProtocol {
    private let fetchFavouritesUseCase: FetchFavouritesUseCaseProtocol
    private let didTapSubject: PassthroughSubject<Int, Never>

    @Published private(set) var movieRowVMs: [MovieRowViewModel] = []

    init(fetchFavouritesUseCase: FetchFavouritesUseCaseProtocol,
         didTapSubject: PassthroughSubject<Int, Never>) {
        self.fetchFavouritesUseCase = fetchFavouritesUseCase
        self.didTapSubject = didTapSubject
    }

    func onAppear() {
        let favourites = fetchFavouritesUseCase.execute()
        movieRowVMs = favourites.map {
            MovieRowViewModel(movie: $0, didTapSubject: didTapSubject)
        }
    }
}
