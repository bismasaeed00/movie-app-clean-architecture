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

    let posterURL: URL?
    let title: String
    let rating: String
    let releaseYear: String
    let overview: String

    let didTapSubject: PassthroughSubject<Int, Never>

    init(movie: Movie, didTapSubject: PassthroughSubject<Int, Never>) {
        self.movie = movie
        self.posterURL = movie.posterURL
        self.title = movie.title
        self.rating = movie.formattedRating
        self.releaseYear = movie.formattedYear
        self.overview = movie.overview
        self.didTapSubject = didTapSubject
    }

    func onTap() {
        didTapSubject.send(movie.id)
    }
}
