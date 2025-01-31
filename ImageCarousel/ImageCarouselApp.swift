

import SwiftUI

@main
struct ImageCarouselApp: App {
    @State private var store = Store()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}

