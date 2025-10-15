//
//  RecipeDetailView.swift
//  RecipeSaver
//
//  Created by Bishal Paudel on 10/15/25.
//

import SwiftUI
internal import CoreData

struct RecipeDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    let recipe: Recipe
    @State private var showDeleteAlert = false
    @State private var exportMessage = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(recipe.name ?? "")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)

                HStack {
                    Text("Category: \(recipe.category ?? "")")
                    Spacer()
                    Text("Time: \(recipe.time) mins")
                }
                .foregroundColor(Color.gray.opacity(0.7))

                Divider().background(Color.gray)

                Text("Ingredients").font(.headline).foregroundColor(.white)
                Text(recipe.ingredients ?? "")
                    .foregroundColor(Color.white.opacity(0.9))

                Divider().background(Color.gray)

                if let notes = recipe.notes, !notes.isEmpty {
                    Text("Notes").font(.headline).foregroundColor(.white)
                    Text(notes)
                        .foregroundColor(Color.white.opacity(0.9))
                }

                Divider().background(Color.gray)

                Button(action: exportToFile) {
                    Text("Export to TXT")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top)

                if !exportMessage.isEmpty {
                    Text(exportMessage)
                        .font(.footnote)
                        .foregroundColor(.green)
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationTitle("Recipe Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Delete Recipe?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewContext.delete(recipe)
                try? viewContext.save()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
        .preferredColorScheme(.dark)
    }

    private func exportToFile() {
        let fileName = "\(recipe.name ?? "Recipe").txt"
        let content = """
        Name: \(recipe.name ?? "")
        Category: \(recipe.category ?? "")
        Time: \(recipe.time) mins

        Ingredients:
        \(recipe.ingredients ?? "")

        Notes:
        \(recipe.notes ?? "")
        """

        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = url.appendingPathComponent(fileName)

        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
            exportMessage = "Exported to \(fileName)"
        } catch {
            exportMessage = "Export failed."
        }
    }
}
