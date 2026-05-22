//
//  FavouriteRepository.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import CoreData
import Foundation

final class FavouriteRepository: FavouriteRepositoryProtocol {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    @MainActor
    func fetchFavourites() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "favourite == %@", NSNumber(value: true))
        do {
            return try coreDataStack.context.fetch(request).map(MovieMapper.toDomain)
        } catch {
            print("Fetch favourites error: \(error)")
            return []
        }
    }

    @MainActor
    func toggleFavourite(movieId: Int, isFavourite: Bool) {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        request.fetchLimit = 1
        do {
            guard let entity = try coreDataStack.context.fetch(request).first else { return }
            entity.favourite = isFavourite
            coreDataStack.saveContext()
        } catch {
            print("Toggle favourite error: \(error)")
        }
    }

    @MainActor
    func isFavourite(movieId: Int) -> Bool {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d AND favourite == %@", movieId, NSNumber(value: true))
        request.fetchLimit = 1
        return (try? coreDataStack.context.fetch(request).first) != nil
    }
}
