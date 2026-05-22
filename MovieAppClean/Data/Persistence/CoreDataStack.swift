//
//  CoreDataStack.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import CoreData
import Foundation

final class CoreDataStack {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieAppClean")
        container.loadPersistentStores { _, error in
            guard let error else { return }
            fatalError("Core Data failed to load: \(error.localizedDescription)")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    @MainActor
    func saveContext() {
        let ctx = context
        guard ctx.hasChanges else { return }
        do {
            try ctx.save()
        } catch {
            print("Core Data save error: \(error.localizedDescription)")
        }
    }

    // Runs `block` on a private background context, saves on success, and returns the result.
    func performBackgroundTask<T: Sendable>(_ block: @escaping @Sendable (NSManagedObjectContext) throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { bgContext in
                do {
                    let result = try block(bgContext)
                    if bgContext.hasChanges {
                        try bgContext.save()
                    }
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
