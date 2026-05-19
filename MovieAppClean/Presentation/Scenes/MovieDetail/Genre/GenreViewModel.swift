//
//  GenreViewModel.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import Combine

final class GenreViewModel: GenreViewModelProtocol {
    @Published private(set) var genreNames: [String] = []

    func update(_ genres: [Genre]) {
        genreNames = genres.map { $0.name }
    }
}
