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
    var moviesRouter: MovieRouter { get }
    var favouritesRouter: MovieRouter { get }
}

struct RootTabView<ViewModel: RootTabViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel
    @StateObject private var moviesRouter: MovieRouter
    @StateObject private var favouritesRouter: MovieRouter

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self._moviesRouter = StateObject(wrappedValue: viewModel.moviesRouter)
        self._favouritesRouter = StateObject(wrappedValue: viewModel.favouritesRouter)
    }

    var body: some View {
        TabView {
            NavigationStack(path: $moviesRouter.path) {
                MovieListView(viewModel: viewModel.movieListVM)
                    .navigationDestination(for: MovieNavigationDestination.self) { destination in
                        moviesRouter.buildView(for: destination)
                    }
            }
            .tabItem {
                Label("Movies", systemImage: "film.stack")
            }

            NavigationStack(path: $favouritesRouter.path) {
                FavouritesView(viewModel: viewModel.favouriteListVM)
                    .navigationDestination(for: MovieNavigationDestination.self) { destination in
                        favouritesRouter.buildView(for: destination)
                    }
            }
            .tabItem {
                Label("Favourites", systemImage: "heart.fill")
            }
        }
    }
}
