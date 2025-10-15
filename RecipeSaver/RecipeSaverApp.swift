//
//  RecipeSaverApp.swift
//  RecipeSaver
//
//  Created by Bishal Paudel on 10/15/25.
//

import SwiftUI
import CoreData

@main
struct RecipeSaverApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
