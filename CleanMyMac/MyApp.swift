import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .containerBackground(.ultraThinMaterial, for: .window)
                .frame(minWidth: 1000, minHeight: 700)
        }
    }
}
