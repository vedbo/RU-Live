import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct ContentView: View {
    @EnvironmentObject var dataEngine: CampusDataEngine
    
    // Default to viewing all of New Brunswick / Rutgers campuses
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 40.505, longitude: -74.45),
            distance: 12000,
            pitch: 0
        )
    )
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                MapDashboardView(cameraPosition: $cameraPosition)
                
                FilterAndLogView()
                    .padding()
            }
            .navigationTitle("RU Live Heatmap")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: Binding(
                get: { dataEngine.selectedNode },
                set: { dataEngine.selectedNode = $0 }
            )) { node in
                DetailedVibeView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
