//
//  MovieAppCleanApp.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 10.05.26.
//

import SwiftUI

@main
struct MovieAppCleanApp: App {
    var body: some Scene {
        WindowGroup {
            let deps = DependencyManager.shared
            RootTabView(viewModel: RootTabViewModel(
                fetchMoviesUseCase: deps.fetchMoviesUseCase,
                refreshMoviesUseCase: deps.refreshMoviesUseCase,
                fetchFavouritesUseCase: deps.fetchFavouritesUseCase,
                movieDetailViewModelFactory: deps.movieDetailViewModelFactory
            ))
        }
    }
}
