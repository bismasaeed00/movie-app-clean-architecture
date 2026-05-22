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

    private let factory: MovieDetailViewModelFactoryProtocol

    init(factory: MovieDetailViewModelFactoryProtocol) {
        self.factory = factory
    }

    func navigate(to destination: MovieNavigationDestination) {
        path.append(destination)
    }

    func navigateBack() {
        path.removeLast()
    }

    @MainActor @ViewBuilder
    func buildView(for destination: MovieNavigationDestination) -> some View {
        switch destination {
        case .detail(let movieId):
            if let viewModel = factory.makeMovieDetailViewModel(movieId: movieId) {
                MovieDetailView(viewModel: viewModel)
            }
        }
    }
}
