//
//  FavouriteRepositoryProtocol.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

protocol FavouriteRepositoryProtocol {
    @MainActor func fetchFavourites() -> [Movie]
    @MainActor func toggleFavourite(movieId: Int, isFavourite: Bool)
    @MainActor func isFavourite(movieId: Int) -> Bool
}
