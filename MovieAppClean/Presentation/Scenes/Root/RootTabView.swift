//
//  RootTabView.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import Combine
import SwiftUI

@MainActor
protocol RootTabViewModelProtocol: ObservableObject {
    associatedtype MovieVM: MovieListViewModelProtocol
    associatedtype FavouriteVM: FavouritesViewModelProtocol

    var movieListVM: MovieVM { get }
    var favouriteListVM: FavouriteVM { get }
    var movieRouter: MovieRouter { get }
}

struct RootTabView<ViewModel: RootTabViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel
    @StateObject private var movieRouter: MovieRouter

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self._movieRouter = StateObject(wrappedValue: viewModel.movieRouter)
    }

    var body: some View {
        TabView {
            NavigationStack(path: $movieRouter.path) {
                MovieListView(viewModel: viewModel.movieListVM)
                    .navigationDestination(for: MovieNavigationDestination.self) { destination in
                        movieRouter.buildView(for: destination)
                    }
            }
            .tabItem {
                Label("Movies", systemImage: "film.stack")
            }

            NavigationStack(path: $movieRouter.path) {
                FavouritesView(viewModel: viewModel.favouriteListVM)
                    .navigationDestination(for: MovieNavigationDestination.self) { destination in
                        movieRouter.buildView(for: destination)
                    }
            }
            .tabItem {
                Label("Favourites", systemImage: "heart.fill")
            }
        }
    }
}
