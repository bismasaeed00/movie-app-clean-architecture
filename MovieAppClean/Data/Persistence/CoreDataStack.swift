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

    func saveContext() {
        let ctx = context
        guard ctx.hasChanges else { return }
        do {
            try ctx.save()
        } catch {
            print("Core Data save error: \(error.localizedDescription)")
        }
    }
}
