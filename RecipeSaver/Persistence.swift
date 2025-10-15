//
//  Persistence.swift
//  RecipeSaver
//
//  Created by Bishal Paudel on 10/15/25.
//

import SwiftUI
internal import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Add sample recipes for preview
        for i in 1...5 {
            let newRecipe = Recipe(context: viewContext)
            newRecipe.name = "Sample Recipe \(i)"
            newRecipe.category = ["Main", "Dessert", "Snack", "Drink"][i % 4]
            newRecipe.time = Int16(15 * i)
            newRecipe.ingredients = "Sample Ingredients for recipe \(i)"
            newRecipe.notes = "Some notes for recipe \(i)"
        }
        try? viewContext.save()
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RecipeSaver")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}
