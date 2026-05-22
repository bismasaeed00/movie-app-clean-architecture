//
//  FavouritesView.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import Combine
import SwiftUI

@MainActor
protocol FavouritesViewModelProtocol: ObservableObject {
    var movieRowVMs: [MovieRowViewModel] { get }

    func onAppear()
}

struct FavouritesView<ViewModel: FavouritesViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            if viewModel.movieRowVMs.isEmpty {
                EmptyStateView(
                    icon: "heart.slash",
                    title: "No Favourites Yet",
                    message: "Mark movies as favourite on the detail page."
                )
            } else {
                List(viewModel.movieRowVMs) { movieVM in
                    MovieRowView(viewModel: movieVM)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Favourites")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.onAppear()
        }
    }
}
