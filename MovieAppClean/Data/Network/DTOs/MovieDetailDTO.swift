//
//  MovieDetailDTO.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

struct MovieDetailDTO: Codable {
    let id: Int
    let runtime: Int
    let genres: [GenreDTO]
}
