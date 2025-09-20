

import SwiftUI

struct ContentView: View {
    @StateObject private var storeManager = StoreKitManager()
    var body: some View {
        
            TestMain(storeManager: storeManager)
    }
}

#Preview {
    ContentView()
        .environment(Store())
}
