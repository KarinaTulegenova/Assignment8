import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss

    let onSave: (Recipe) -> Void

    @State private var title = ""
    @State private var cuisine = ""
    @State private var prepMinutesText = ""
    @State private var difficulty = "Easy"

    @State private var ingredientText1 = ""
    @State private var ingredientText2 = ""
    @State private var stepText1 = ""
    @State private var stepText2 = ""

    private let difficulties = ["Easy", "Medium", "Hard"]

    private var prepMinutes: Int? { Int(prepMinutesText) }

    private var isValid: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !cuisine.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard let p = prepMinutes, p > 0 else { return false }

        let ingredients = [ingredientText1, ingredientText2]
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        let steps = [stepText1, stepText2]
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        return ingredients.count >= 2 && steps.count >= 2
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic") {
                    TextField("Title", text: $title)
                    TextField("Cuisine", text: $cuisine)

                    TextField("Prep minutes", text: $prepMinutesText)
                        .keyboardType(.numberPad)

                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) { Text($0) }
                    }
                }

                Section("Ingredients (min 2)") {
                    TextField("Ingredient 1", text: $ingredientText1)
                    TextField("Ingredient 2", text: $ingredientText2)
                }

                Section("Steps (min 2)") {
                    TextField("Step 1", text: $stepText1)
                    TextField("Step 2", text: $stepText2)
                }
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let ingredients = [ingredientText1, ingredientText2]
                            .map { $0.trimmingCharacters(in: .whitespaces) }

                        let steps = [stepText1, stepText2]
                            .map { $0.trimmingCharacters(in: .whitespaces) }

                        let recipe = Recipe.new(
                            title: title.trimmingCharacters(in: .whitespaces),
                            cuisine: cuisine.trimmingCharacters(in: .whitespaces),
                            prepMinutes: Int(prepMinutesText) ?? 1,
                            difficulty: difficulty,
                            ingredients: ingredients,
                            steps: steps
                        )
                        onSave(recipe)
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}
