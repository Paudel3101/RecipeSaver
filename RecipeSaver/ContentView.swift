//
//  ContentView.swift
//  RecipeSaver
//
//  Created by Bishal Paudel on 10/15/25.
//

import SwiftUI
internal import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Recipe.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)])
    var recipes: FetchedResults<Recipe>
    
    @State private var previewRecipe: Recipe? = nil
    @State private var showPreview = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes) { recipe in
                    NavigationLink(destination: RecipeFormView(recipe: recipe)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(recipe.name ?? "Unnamed")
                                    .font(.headline)
                                HStack {
                                    Text(recipe.category ?? "No Category")
                                    Spacer()
                                    Text("\(recipe.time) mins")
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .contentShape(Rectangle()) // full row tappable
                    }
                    .simultaneousGesture(
                        LongPressGesture()
                            .onEnded { _ in
                                previewRecipe = recipe
                                showPreview = true
                            }
                    )
                }
                .onDelete(perform: deleteRecipes)
            }
            .navigationTitle("My Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RecipeFormView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showPreview) {
                if let recipe = previewRecipe {
                    NavigationView {
                        RecipeDetailView(recipe: recipe)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Close") {
                                        showPreview = false
                                    }
                                }
                            }
                    }
                }
            }
        }
    }

    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            offsets.map { recipes[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}
