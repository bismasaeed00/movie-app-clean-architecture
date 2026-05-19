//
//  DependencyManager.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import Combine

final class DependencyManager {
    static let shared = DependencyManager()

    private let coreDataStack: CoreDataStack
    private let apiClient: APIClient

    let movieRepository: MovieRepositoryProtocol
    let favouriteRepository: FavouriteRepositoryProtocol

    private init() {
        coreDataStack = CoreDataStack()
        apiClient = APIClient()
        movieRepository = MovieRepository(apiClient: apiClient, coreDataStack: coreDataStack)
        favouriteRepository = FavouriteRepository(coreDataStack: coreDataStack)
    }
}
