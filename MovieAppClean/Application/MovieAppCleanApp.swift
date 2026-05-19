//
//  MovieAppCleanApp.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 10.05.26.
//

import SwiftUI
import CoreData

@main
struct MovieAppCleanApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView(viewModel: RootTabViewModel(movieRepository: DependencyManager.shared.movieRepository,
                                                    favouriteRepository: DependencyManager.shared.favouriteRepository))
        }
    }
}
