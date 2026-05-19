//
//  FavouriteRepository.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import CoreData
import Foundation

protocol FavouriteRepositoryProtocol {
    func fetchFavourites() -> [Movie]
    func toggleFavourite(movieId: Int, isFavourite: Bool)
    func isFavourite(movieId: Int) -> Bool
}

final class FavouriteRepository: FavouriteRepositoryProtocol {
    private let coreDataStack: CoreDataStack
    private var context: NSManagedObjectContext {
        coreDataStack.context
    }

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    @MainActor
    func fetchFavourites() -> [Movie] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "favourite == %@", NSNumber(value: true))
        do {
            return try context.fetch(request).map(MovieMapper.toDomain)
        } catch {
            print("Fetch favourites error: \(error)")
            return []
        }
    }

    func toggleFavourite(movieId: Int, isFavourite: Bool) {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movieId)
        request.fetchLimit = 1
        do {
            guard let entity = try context.fetch(request).first else { return }
            entity.favourite = isFavourite
            coreDataStack.saveContext()
        } catch {
            print("Toggle favourite error: \(error)")
        }
    }

    func isFavourite(movieId: Int) -> Bool {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d AND favourite == %@", movieId, NSNumber(value: true))
        request.fetchLimit = 1
        return (try? context.fetch(request).first) != nil
    }
}
