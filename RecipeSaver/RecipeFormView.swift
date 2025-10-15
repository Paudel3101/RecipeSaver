//
//  RecipeFormView.swift
//  RecipeSaver
//
//  Created by Bishal Paudel on 10/15/25.
//

import SwiftUI
internal import CoreData

struct RecipeFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    var recipe: Recipe? = nil

    @State private var name = ""
    @State private var category = "Main"
    @State private var time = 10
    @State private var ingredients = ""
    @State private var notes = ""
    @State private var showAlert = false

    let categories = ["Main", "Dessert", "Snack", "Drink"]

    var body: some View {
        Form {
            Section(header: Text("Recipe Info")) {
                TextField("Name", text: $name)
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { Text($0) }
                }
                Stepper("Time: \(time) mins", value: $time, in: 1...240)
            }

            Section(header: Text("Ingredients")) {
                TextEditor(text: $ingredients)
                    .frame(height: 100)
            }

            Section(header: Text("Notes (Optional)")) {
                TextEditor(text: $notes)
                    .frame(height: 80)
            }
        }
        .navigationTitle(recipe == nil ? "Add Recipe" : "Edit Recipe")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") { saveRecipe() }
            }
        }
        .alert("Please fill in the name and ingredients.", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            if let recipe = recipe {
                name = recipe.name ?? ""
                category = recipe.category ?? "Main"
                time = Int(recipe.time)
                ingredients = recipe.ingredients ?? ""
                notes = recipe.notes ?? ""
            }
        }
    }

    private func saveRecipe() {
        guard !name.isEmpty, !ingredients.isEmpty else {
            showAlert = true
            return
        }

        let r = recipe ?? Recipe(context: viewContext)
        r.name = name
        r.category = category
        r.time = Int16(time)
        r.ingredients = ingredients
        r.notes = notes

        try? viewContext.save()
        dismiss()
    }
}

struct RecipeFormView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext

        // Preview adding new recipe
        RecipeFormView()
            .environment(\.managedObjectContext, context)
        
        // Preview editing existing recipe
        let sampleRecipe = Recipe(context: context)
        sampleRecipe.name = "Sample Recipe"
        sampleRecipe.category = "Main"
        sampleRecipe.time = 30
        sampleRecipe.ingredients = "Sample ingredients here."
        sampleRecipe.notes = "Sample notes."

        return RecipeFormView(recipe: sampleRecipe)
            .environment(\.managedObjectContext, context)
    }
}
