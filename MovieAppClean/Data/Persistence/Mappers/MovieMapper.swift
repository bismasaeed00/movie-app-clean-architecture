//
//  MovieMapper.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import CoreData

enum MovieMapper {

    // MARK: - DTO → Domain
    static func toDomain(_ dto: MovieDTO, isFavourite: Bool = false) -> Movie {
        Movie(id: dto.id,
              title: dto.title,
              overview: dto.overview,
              posterPath: dto.posterPath,
              releaseDate: dto.releaseDate,
              voteAverage: dto.voteAverage,
              isFavourite: isFavourite,
              genres: [],
              runtime: nil)
    }

    // MARK: - ManagedObject → Domain
    static func toDomain(_ entity: MovieEntity) -> Movie {
        let genres = (entity.genres as? Set<GenreEntity> ?? []).map { genreEntity in
            Genre(id: Int(genreEntity.id), name: genreEntity.name ?? "")
        }.sorted { $0.id < $1.id }

        return Movie(id: Int(entity.id),
                     title: entity.title ?? "",
                     overview: entity.overview ?? "",
                     posterPath: entity.posterPath,
                     releaseDate: entity.releaseDate,
                     voteAverage: entity.voteAverage,
                     isFavourite: entity.favourite,
                     genres: genres,
                     runtime: entity.runtime > 0 ? Int(entity.runtime) : nil)
    }

    // MARK: - DTO → new ManagedObject
    static func toEntity(_ dto: MovieDTO, context: NSManagedObjectContext) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.id = Int64(dto.id)
        entity.title = dto.title
        entity.overview = dto.overview
        entity.posterPath = dto.posterPath
        entity.releaseDate = dto.releaseDate
        entity.voteAverage = dto.voteAverage
        entity.favourite = false
        return entity
    }

    // MARK: - Update existing ManagedObject from DTO (preserves isFavourite)
    static func update(_ entity: MovieEntity, with dto: MovieDTO) {
        entity.title = dto.title
        entity.overview = dto.overview
        entity.posterPath = dto.posterPath
        entity.voteAverage = dto.voteAverage
    }

    // MARK: - Merge MovieDetailDTO into existing ManagedObject
    static func mergeDetail(_ detailDTO: MovieDetailDTO,
                            into entity: MovieEntity,
                            context: NSManagedObjectContext) {
        entity.runtime = Int64(detailDTO.runtime)

        // Remove old genres to avoid duplicates on re-fetch
        if let oldGenres = entity.genres as? Set<GenreEntity> {
            oldGenres.forEach { context.delete($0) }
        }

        for genreDTO in detailDTO.genres {
            let genreEntity = GenreEntity(context: context)
            genreEntity.id = Int64(genreDTO.id)
            genreEntity.name = genreDTO.name
            entity.addToGenres(genreEntity)
        }
    }
}
