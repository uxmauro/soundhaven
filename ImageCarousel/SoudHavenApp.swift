

import SwiftUI

@main
struct SoundHaven: App {
    @State private var store = Store()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .preferredColorScheme(.dark) // Forces dark mode globally
        }
    }
}

