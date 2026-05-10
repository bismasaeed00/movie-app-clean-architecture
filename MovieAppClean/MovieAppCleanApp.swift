//
//  MovieAppCleanApp.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 10.05.26.
//

import SwiftUI
import CoreData

@main
struct MovieAppCleanApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
