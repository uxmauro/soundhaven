

import SwiftUI

struct ContentView: View {
    var body: some View {
        
            Main()
                .tabItem {
                    Label("ScrollView+  ", systemImage: "3.circle.fill")
                }
    }
}

#Preview {
    ContentView()
        .environment(Store())
}
