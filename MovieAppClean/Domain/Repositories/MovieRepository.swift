//
//  MovieRepository.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import CoreData
import Foundation

protocol MovieRepositoryProtocol {
    func fetchMovies(page: Int) async throws -> PaginatedMovies
    func refreshMovies() async throws -> PaginatedMovies
    func fetchMovieDetail(movieId: Int) async throws -> Movie
    func cachedPaginationInfo() -> (highestPage: Int, totalPages: Int)

    @MainActor func cachedMovies() -> [Movie]
    @MainActor func cachedMovie(movieId: Int) -> Movie?
}

final class MovieRepository: MovieRepositoryProtocol {
    private let apiClient: APIClient
    private let coreDataStack: CoreDataStack

    private var context: NSManagedObjectContext {
        coreDataStack.context
    }

    init(apiClient: APIClient, coreDataStack: CoreDataStack) {
        self.apiClient = apiClient
        self.coreDataStack = coreDataStack
    }

    func fetchMovies(page: Int) async throws -> PaginatedMovies {
        let dto: MovieListResponseDTO = try await apiClient.request(.discoverMovies(page: page))
        saveOrUpdateMoviePage(dto: dto, page: page)
        return buildPaginatedMovies(from: dto)
    }

    func refreshMovies() async throws -> PaginatedMovies {
        let dto: MovieListResponseDTO = try await apiClient.request(.discoverMovies(page: 1))
        saveOrUpdateMoviePage(dto: dto, page: 1)
        return buildPaginatedMovies(from: dto)
    }

    func fetchMovieDetail(movieId: Int) async throws -> Movie {
        let detailDTO: MovieDetailDTO = try await apiClient.request(.movieDetail(id: movieId))

        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        request.fetchLimit = 1

        do {
            if let entity = try context.fetch(request).first {
                MovieMapper.mergeDetail(detailDTO, into: entity, context: context)
                coreDataStack.saveContext()
                return MovieMapper.toDomain(entity)
            }
        } catch {
            print("Detail merge error: \(error)")
        }

        return Movie(id: detailDTO.id,
                     title: "",
                     overview: "",
                     posterPath: nil,
                     releaseDate: nil,
                     voteAverage: 0,
                     isFavourite: false,
                     genres: detailDTO.genres.map { Genre(id: $0.id, name: $0.name) },
                     runtime: detailDTO.runtime)
    }

    func cachedPaginationInfo() -> (highestPage: Int, totalPages: Int) {
        let request: NSFetchRequest<ResponseEntity> = ResponseEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            guard !entities.isEmpty else { return (0, 0) }
            let highestPage = entities.map { Int($0.page) }.max() ?? 0
            let totalPages = Int(entities.first?.total_pages ?? 0)
            return (highestPage, totalPages)
        } catch {
            return (0, 0)
        }
    }

    @MainActor
    func cachedMovies() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            return try context.fetch(request).map(MovieMapper.toDomain)
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
            return try context.fetch(request).map(MovieMapper.toDomain).first
        } catch {
            print("Cached movies fetch error: \(error)")
            return nil
        }
    }

    // MARK: - Private helpers
    private func saveOrUpdateMoviePage(dto: MovieListResponseDTO, page: Int) {
        let request: NSFetchRequest<ResponseEntity> = ResponseEntity.fetchRequest()
        request.predicate = NSPredicate(format: "page == %d", page)

        do {
            let cachedResponses = try context.fetch(request)
            var existingMovies: [Int: MovieEntity] = [:]
            for response in cachedResponses {
                for movie in response.movies as? Set<MovieEntity> ?? [] {
                    existingMovies[Int(movie.id)] = movie
                }
            }

            if !cachedResponses.isEmpty {
                for dto in dto.results {
                    if let existing = existingMovies[dto.id] {
                        MovieMapper.update(existing, with: dto)
                    } else {
                        let entity = MovieMapper.toEntity(dto, context: context)
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

            coreDataStack.saveContext()
        } catch {
            print("Save/update movies error: \(error)")
        }
    }

    private func buildPaginatedMovies(from dto: MovieListResponseDTO) -> PaginatedMovies {
        let (highestPage, _) = cachedPaginationInfo()
        let movies = cachedMovies()
        return PaginatedMovies(movies: movies,
                               currentPage: highestPage > 0 ? highestPage : dto.page,
                               totalPages: dto.totalPages)
    }
}
