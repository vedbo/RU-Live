import SwiftUI

@main
@available(iOS 17.0, *)
struct MyApp: App {
    @StateObject private var dataEngine = CampusDataEngine()
    
    var body: some Scene {
        WindowGroup {
            HomeSearchView()
                .environmentObject(dataEngine)
        }
    }
}
