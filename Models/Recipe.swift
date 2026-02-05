import Foundation

struct Recipe: Identifiable {
    var id: String
    var title: String
    var cuisine: String
    var prepMinutes: Int
    var difficulty: String
    var ingredients: [String]
    var steps: [String]
    var isFavorite: Bool
    var createdAt: TimeInterval

    func toDictionary() -> [String: Any] {
        [
            "title": title,
            "cuisine": cuisine,
            "prepMinutes": prepMinutes,
            "difficulty": difficulty,
            "ingredients": ingredients,
            "steps": steps,
            "isFavorite": isFavorite,
            "createdAt": createdAt
        ]
    }

    init?(id: String, dict: [String: Any]) {
        guard
            let title = dict["title"] as? String,
            let cuisine = dict["cuisine"] as? String,
            let prepMinutes = dict["prepMinutes"] as? Int,
            let difficulty = dict["difficulty"] as? String,
            let ingredients = dict["ingredients"] as? [String],
            let steps = dict["steps"] as? [String],
            let isFavorite = dict["isFavorite"] as? Bool,
            let createdAt = dict["createdAt"] as? TimeInterval
        else { return nil }

        self.id = id
        self.title = title
        self.cuisine = cuisine
        self.prepMinutes = prepMinutes
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.steps = steps
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }

    // Удобный init для создания в форме
    static func new(title: String,
                    cuisine: String,
                    prepMinutes: Int,
                    difficulty: String,
                    ingredients: [String],
                    steps: [String]) -> Recipe {
        Recipe(
            id: UUID().uuidString, // временно, в Firebase перезапишется автоID
            title: title,
            cuisine: cuisine,
            prepMinutes: prepMinutes,
            difficulty: difficulty,
            ingredients: ingredients,
            steps: steps,
            isFavorite: false,
            createdAt: Date().timeIntervalSince1970
        )!
    }

    private init?(id: String,
                  title: String,
                  cuisine: String,
                  prepMinutes: Int,
                  difficulty: String,
                  ingredients: [String],
                  steps: [String],
                  isFavorite: Bool,
                  createdAt: TimeInterval) {
        self.id = id
        self.title = title
        self.cuisine = cuisine
        self.prepMinutes = prepMinutes
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.steps = steps
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
}
