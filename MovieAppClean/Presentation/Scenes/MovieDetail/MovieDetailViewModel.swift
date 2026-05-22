//
//  MovieDetailViewModel.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import Combine
import Foundation

@MainActor
final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    private var movie: Movie
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol
    private let toggleFavouriteUseCase: ToggleFavouriteUseCaseProtocol

    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var genreVM: GenreViewModel
    @Published private(set) var hasGenre: Bool = false
    @Published private(set) var isFavourite: Bool

    var title: String { movie.title }

    var releaseYear: String {
        guard let date = movie.releaseDate, date.count >= 4 else { return "N/A" }
        return String(date.prefix(4))
    }

    var rating: String {
        String(format: "%.1f", movie.voteAverage)
    }

    var overview: String {
        movie.overview.isEmpty ? "No overview available." : movie.overview
    }

    var posterURL: URL? {
        movie.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
    }

    var runtimeText: String {
        guard let runtime = movie.runtime, runtime > 0 else { return "N/A" }
        return "\(runtime) min"
    }

    init(movie: Movie,
         fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol,
         toggleFavouriteUseCase: ToggleFavouriteUseCaseProtocol) {
        self.movie = movie
        self.isFavourite = movie.isFavourite
        self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
        self.toggleFavouriteUseCase = toggleFavouriteUseCase
        self.genreVM = GenreViewModel()
    }

    func onAppear() async {
        isLoading = true
        do {
            movie = try await fetchMovieDetailUseCase.execute(movieId: movie.id)
            genreVM.update(movie.genres)
            hasGenre = !movie.genres.isEmpty
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func toggleFavourite() {
        let newValue = !movie.isFavourite
        toggleFavouriteUseCase.execute(movieId: movie.id, isFavourite: newValue)
        movie.isFavourite = newValue
        isFavourite = newValue
    }
}
