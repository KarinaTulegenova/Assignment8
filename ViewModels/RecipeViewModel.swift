import Foundation
import Foundation
import Combine
@MainActor
final class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorText: String? = nil

    private let service = RecipeService()
    private var started = false

    func start() {
        guard !started else { return }
        started = true

        isLoading = true
        errorText = nil

        service.observeRecipes { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let list):
                self.recipes = list
                self.isLoading = false
                self.errorText = nil
            case .failure(let error):
                self.isLoading = false
                self.errorText = error.localizedDescription
            }
        }
    }

    func add(recipe: Recipe) {
        isLoading = true
        service.addRecipe(recipe) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.errorText = error?.localizedDescription
            }
        }
    }

    func delete(id: String) {
        service.deleteRecipe(recipeId: id) { [weak self] error in
            DispatchQueue.main.async {
                self?.errorText = error?.localizedDescription
            }
        }
    }

    func toggleFavorite(id: String, newValue: Bool) {
        service.toggleFavorite(recipeId: id, isFavorite: newValue) { [weak self] error in
            DispatchQueue.main.async {
                self?.errorText = error?.localizedDescription
            }
        }
    }
}
