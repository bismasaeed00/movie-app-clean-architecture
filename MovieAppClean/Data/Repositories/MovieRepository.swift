//
//  MovieRepository.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import CoreData
import Foundation

enum MovieRepositoryError: Error, LocalizedError {
    case movieNotFound

    var errorDescription: String? {
        "Movie details could not be found."
    }
}

final class MovieRepository: MovieRepositoryProtocol {
    private let apiClient: APIClient
    private let coreDataStack: CoreDataStack

    init(apiClient: APIClient, coreDataStack: CoreDataStack) {
        self.apiClient = apiClient
        self.coreDataStack = coreDataStack
    }

    func fetchMovies(page: Int) async throws -> PaginatedMovies {
        let dto: MovieListResponseDTO = try await apiClient.request(.discoverMovies(page: page))
        return try await coreDataStack.performBackgroundTask { bgContext in
            try Self.saveOrUpdateMoviePage(dto: dto, page: page, context: bgContext)
            return Self.buildPaginatedMovies(from: dto, context: bgContext)
        }
    }

    func refreshMovies() async throws -> PaginatedMovies {
        let dto: MovieListResponseDTO = try await apiClient.request(.discoverMovies(page: 1))
        return try await coreDataStack.performBackgroundTask { bgContext in
            try Self.saveOrUpdateMoviePage(dto: dto, page: 1, context: bgContext)
            return Self.buildPaginatedMovies(from: dto, context: bgContext)
        }
    }

    func fetchMovieDetail(movieId: Int) async throws -> Movie {
        let detailDTO: MovieDetailDTO = try await apiClient.request(.movieDetail(id: movieId))
        return try await coreDataStack.performBackgroundTask { bgContext in
            let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieId)
            request.fetchLimit = 1
            guard let entity = try bgContext.fetch(request).first else {
                throw MovieRepositoryError.movieNotFound
            }
            MovieMapper.mergeDetail(detailDTO, into: entity, context: bgContext)
            return MovieMapper.toDomain(entity)
        }
    }

    @MainActor
    func cachedMovies() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            return try coreDataStack.context.fetch(request).map(MovieMapper.toDomain)
        } catch {
            print("Cached movies fetch error: \(error)")
            return []
        }
    }

    @MainActor
    func cachedMovie(movieId: Int) -> Movie? {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        request.fetchLimit = 1
        do {
            return try coreDataStack.context.fetch(request).map(MovieMapper.toDomain).first
        } catch {
            print("Cached movie fetch error: \(error)")
            return nil
        }
    }

    // MARK: - Private static helpers (no self capture needed in background closures)

    private static func saveOrUpdateMoviePage(
        dto: MovieListResponseDTO,
        page: Int,
        context: NSManagedObjectContext
    ) throws {
        let request: NSFetchRequest<ResponseEntity> = ResponseEntity.fetchRequest()
        request.predicate = NSPredicate(format: "page == %d", page)

        let cachedResponses = try context.fetch(request)
        var existingMovies: [Int: MovieEntity] = [:]
        for response in cachedResponses {
            for movie in response.movies as? Set<MovieEntity> ?? [] {
                existingMovies[Int(movie.id)] = movie
            }
        }

        if !cachedResponses.isEmpty {
            for movieDTO in dto.results {
                if let existing = existingMovies[movieDTO.id] {
                    MovieMapper.update(existing, with: movieDTO)
                } else {
                    let entity = MovieMapper.toEntity(movieDTO, context: context)
                    cachedResponses.first?.addToMovies(entity)
                }
            }
        } else {
            let responseEntity = ResponseEntity(context: context)
            responseEntity.page = Int64(dto.page)
            responseEntity.total_pages = Int64(dto.totalPages)
            for movieDTO in dto.results {
                let entity = MovieMapper.toEntity(movieDTO, context: context)
                responseEntity.addToMovies(entity)
            }
        }
    }

    private static func buildPaginatedMovies(
        from dto: MovieListResponseDTO,
        context: NSManagedObjectContext
    ) -> PaginatedMovies {
        let (highestPage, _) = cachedPaginationInfo(context: context)
        let movies = allCachedMovies(context: context)
        return PaginatedMovies(
            movies: movies,
            currentPage: highestPage > 0 ? highestPage : dto.page,
            totalPages: dto.totalPages
        )
    }

    private static func allCachedMovies(context: NSManagedObjectContext) -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        return (try? context.fetch(request))?.map(MovieMapper.toDomain) ?? []
    }

    private static func cachedPaginationInfo(
        context: NSManagedObjectContext
    ) -> (highestPage: Int, totalPages: Int) {
        let request: NSFetchRequest<ResponseEntity> = ResponseEntity.fetchRequest()
        guard let entities = try? context.fetch(request), !entities.isEmpty else { return (0, 0) }
        let highestPage = entities.map { Int($0.page) }.max() ?? 0
        let totalPages = Int(entities.first?.total_pages ?? 0)
        return (highestPage, totalPages)
    }
}
