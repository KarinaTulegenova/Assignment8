import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                .accessibilityLabel(recipe.isFavorite ? "Favorite" : "Not favorite")

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title).font(.headline)
                Text("\(recipe.cuisine) • \(recipe.prepMinutes) min • \(recipe.difficulty)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}
