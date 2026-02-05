import Foundation
import FirebaseDatabase

final class RecipeService {
    private let rootRef = Database.database().reference()
    private var recipesRef: DatabaseReference { rootRef.child("recipes") }

    private var handle: DatabaseHandle?

    func addRecipe(_ recipe: Recipe, completion: @escaping (Error?) -> Void) {
        let newRef = recipesRef.childByAutoId()
        newRef.setValue(recipe.toDictionary()) { error, _ in
            completion(error)
        }
    }

    func observeRecipes(onChange: @escaping (Result<[Recipe], Error>) -> Void) {
        // снимаем предыдущий listener, если был
        if let handle = handle {
            recipesRef.removeObserver(withHandle: handle)
        }

        handle = recipesRef.observe(.value, with: { snapshot in
            var list: [Recipe] = []

            for child in snapshot.children {
                guard
                    let snap = child as? DataSnapshot,
                    let dict = snap.value as? [String: Any],
                    let recipe = Recipe(id: snap.key, dict: dict)
                else { continue }
                list.append(recipe)
            }

            // удобно сортировать по createdAt (новые сверху)
            list.sort { $0.createdAt > $1.createdAt }

            onChange(.success(list))
        }, withCancel: { error in
            onChange(.failure(error))
        })
    }

    func toggleFavorite(recipeId: String, isFavorite: Bool, completion: @escaping (Error?) -> Void) {
        recipesRef.child(recipeId).child("isFavorite").setValue(isFavorite) { error, _ in
            completion(error)
        }
    }

    func deleteRecipe(recipeId: String, completion: @escaping (Error?) -> Void) {
        recipesRef.child(recipeId).removeValue { error, _ in
            completion(error)
        }
    }

    deinit {
        if let handle = handle {
            recipesRef.removeObserver(withHandle: handle)
        }
    }
}
