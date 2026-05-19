//
//  MovieListView.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import Combine
import SwiftUI

@MainActor
protocol MovieListViewModelProtocol: ObservableObject {
    var navigationTitle: String { get }
    var movieRowVMs: [MovieRowViewModel] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var hasMorePages: Bool { get }
    var nextPageTitle: String { get }

    func onAppear() async
    func refresh() async
    func loadNextPage() async
}

struct MovieListView<ViewModel: MovieListViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        content
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            }
            .task {
                await viewModel.onAppear()
            }
            .refreshable {
                await viewModel.refresh()
            }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if let error = viewModel.errorMessage, viewModel.movieRowVMs.isEmpty {
            ErrorView(message: error) {
                Task { await viewModel.onAppear() }
            }
        } else if viewModel.movieRowVMs.isEmpty && !viewModel.isLoading {
            EmptyStateView()
        } else {
            movieList
        }
    }

    private var movieList: some View {
        List {
            ForEach(viewModel.movieRowVMs) { movieVM in
                MovieRowView(viewModel: movieVM)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            footerView
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    private var footerView: some View {
        if viewModel.isLoading {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        } else if viewModel.hasMorePages {
            Button(viewModel.nextPageTitle) {
                Task {
                    await viewModel.loadNextPage()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
