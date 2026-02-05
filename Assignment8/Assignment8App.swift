import SwiftUI
import FirebaseCore

@main
struct Assignment8App: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RecipeListView()
        }
    }
}
