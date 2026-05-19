//
//  MovieRouter.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import Combine
import SwiftUI

final class MovieRouter: ObservableObject {
    @Published var path: [MovieNavigationDestination] = []

    private let movieRepository: MovieRepositoryProtocol
    private let favouriteRepository: FavouriteRepositoryProtocol

    init(movieRepository: MovieRepositoryProtocol, favouriteRepository: FavouriteRepositoryProtocol) {
        self.movieRepository = movieRepository
        self.favouriteRepository = favouriteRepository
    }

    func navigate(to destination: MovieNavigationDestination) {
        path.append(destination)
    }

    func navigateBack() {
        path.removeLast()
    }

    @ViewBuilder
    func buildView(for destination: MovieNavigationDestination) -> some View {
        switch destination {
        case .detail(let movieId):
            if let movie = movieRepository.cachedMovie(movieId: movieId) {
                let detailViewModel = MovieDetailViewModel(movie: movie,
                                                           movieRepository: movieRepository,
                                                           favouriteRepository: favouriteRepository)
                MovieDetailView(viewModel: detailViewModel)
            }
        }
    }
}
