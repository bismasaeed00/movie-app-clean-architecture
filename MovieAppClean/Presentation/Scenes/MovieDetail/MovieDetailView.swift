//
//  MovieDetailView.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import SwiftUI

@MainActor
protocol MovieDetailViewModelProtocol: ObservableObject {
    var title: String { get }
    var releaseYear: String { get }
    var rating: String { get }
    var runtimeText: String { get }
    var overview: String { get }
    var isFavourite: Bool { get }
    var posterURL: URL? { get }
    var genreVM: GenreViewModel { get }
    var hasGenre: Bool { get }
    var errorMessage: String? { get }

    func onAppear() async
    func toggleFavourite()
}

struct MovieDetailView<ViewModel: MovieDetailViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.onAppear() }
                }
            } else {
                detailContent
            }
        }
        .task {
            await viewModel.onAppear()
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favouriteButton
            }
        }
    }

    // MARK: - Subviews

    private var detailContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                posterView
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.title)
                        .font(.title.bold())

                    HStack(spacing: 12) {
                        Label(viewModel.releaseYear, systemImage: "calendar")
                        Label(viewModel.rating, systemImage: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    Divider()

                    HStack {
                        Text("Runtime:")
                            .font(.headline)
                        Text(viewModel.runtimeText)
                            .font(.subheadline)
                    }

                    Divider()

                    Text("Overview")
                        .font(.headline)
                    Text(viewModel.overview)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    genreChips
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }

    private var favouriteButton: some View {
        Button {
            viewModel.toggleFavourite()
        } label: {
            Image(systemName: viewModel.isFavourite ? "heart.fill" : "heart")
                .foregroundColor(viewModel.isFavourite ? .red : .primary)
                .font(.body.bold())
        }
    }

    private var posterView: some View {
        AsyncImage(url: viewModel.posterURL) { phase in
            switch phase {
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fit)
            case .failure, .empty:
                Rectangle()
                    .fill(Color(.tertiarySystemBackground))
                    .overlay(Image(systemName: "film").font(.largeTitle))
            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }

    @ViewBuilder
    private var genreChips: some View {
        if viewModel.hasGenre {
            GenreView(viewModel: viewModel.genreVM)
        }
    }
}
