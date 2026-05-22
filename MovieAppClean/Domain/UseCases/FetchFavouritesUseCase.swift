//
//  FetchFavouritesUseCase.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

protocol FetchFavouritesUseCaseProtocol {
    @MainActor func execute() -> [Movie]
}

final class FetchFavouritesUseCase: FetchFavouritesUseCaseProtocol {
    private let favouriteRepository: FavouriteRepositoryProtocol

    init(favouriteRepository: FavouriteRepositoryProtocol) {
        self.favouriteRepository = favouriteRepository
    }

    @MainActor
    func execute() -> [Movie] {
        favouriteRepository.fetchFavourites()
    }
}
