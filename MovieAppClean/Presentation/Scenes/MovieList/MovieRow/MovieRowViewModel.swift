//
//  MovieRowViewModel.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import Combine
import Foundation

final class MovieRowViewModel: MovieRowViewModelProtocol, Identifiable {
    private let movie: Movie
    private let didTapSubject: PassthroughSubject<Int, Never>

    let posterURL: URL?
    let title: String
    let rating: String
    let releaseYear: String
    let overview: String

    init(movie: Movie, didTapSubject: PassthroughSubject<Int, Never>) {
        self.movie = movie
        self.didTapSubject = didTapSubject
        self.posterURL = movie.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
        self.title = movie.title
        self.rating = String(format: "%.1f", movie.voteAverage)
        self.releaseYear = {
            guard let date = movie.releaseDate, date.count >= 4 else { return "N/A" }
            return String(date.prefix(4))
        }()
        self.overview = movie.overview
    }

    func onTap() {
        didTapSubject.send(movie.id)
    }
}
