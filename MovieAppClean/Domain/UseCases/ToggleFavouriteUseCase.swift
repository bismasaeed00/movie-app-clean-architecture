//
//  ToggleFavouriteUseCase.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

protocol ToggleFavouriteUseCaseProtocol {
    func execute(movieId: Int, isFavourite: Bool)
}

final class ToggleFavouriteUseCase: ToggleFavouriteUseCaseProtocol {
    private let favouriteRepository: FavouriteRepositoryProtocol

    init(favouriteRepository: FavouriteRepositoryProtocol) {
        self.favouriteRepository = favouriteRepository
    }

    func execute(movieId: Int, isFavourite: Bool) {
        favouriteRepository.toggleFavourite(movieId: movieId, isFavourite: isFavourite)
    }
}
