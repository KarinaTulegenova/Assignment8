import SwiftUI

struct RecipeListView: View {
    @StateObject private var vm = RecipeViewModel()

    @State private var showAdd = false

    // Extra (Part 7): search + favorites-only toggle
    @State private var searchText = ""
    @State private var favoritesOnly = false

    private var filtered: [Recipe] {
        vm.recipes.filter { r in
            let matchesSearch =
                searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                r.title.localizedCaseInsensitiveContains(searchText) ||
                r.cuisine.localizedCaseInsensitiveContains(searchText)

            let matchesFav = !favoritesOnly || r.isFavorite
            return matchesSearch && matchesFav
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.recipes.isEmpty {
                    ProgressView("Loading...")
                } else if let errorText = vm.errorText, vm.recipes.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.largeTitle)
                        Text("Error")
                            .font(.headline)
                        Text(errorText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Retry") { vm.start() }
                    }
                    .padding()
                } else {
                    List {
                        if favoritesOnly {
                            Text("Showing favorites only")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }

                        ForEach(filtered) { recipe in
                            RecipeRowView(recipe: recipe)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        vm.delete(id: recipe.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        vm.toggleFavorite(id: recipe.id, newValue: !recipe.isFavorite)
                                    } label: {
                                        Label("Favorite", systemImage: recipe.isFavorite ? "heart.slash" : "heart")
                                    }
                                    .tint(.pink)
                                }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        favoritesOnly.toggle()
                    } label: {
                        Image(systemName: favoritesOnly ? "heart.fill" : "heart")
                    }
                    .accessibilityLabel("Favorites only")
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add recipe")
                }
            }
            .searchable(text: $searchText, prompt: "Search by title or cuisine")
            .sheet(isPresented: $showAdd) {
                AddRecipeView { recipe in
                    vm.add(recipe: recipe)
                }
            }
            .onAppear { vm.start() }
        }
    }
}
