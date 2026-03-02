import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct MapDashboardView: View {
    @EnvironmentObject var dataEngine: CampusDataEngine
    @Binding var cameraPosition: MapCameraPosition
    
    var body: some View {
        Map(position: $cameraPosition, selection: $dataEngine.selectedNode) {
            ForEach(dataEngine.nodes) { node in
                // Apply smart filtering
                if dataEngine.selectedFilter == nil || dataEngine.selectedFilter == node.category {
                    Annotation(node.name, coordinate: node.coordinate) {
                        VStack(spacing: 4) {
                            if let event = node.activeEvent {
                                Text(event)
                                    .font(.caption2)
                                    .bold()
                                    .padding(4)
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(6)
                                    .shadow(radius: 3)
                            }
                            MapPinView(node: node)
                                .onTapGesture {
                                    withAnimation {
                                        dataEngine.selectedNode = node
                                    }
                                }
                        }
                    }
                    .tag(node)
                }
            }
        }
        .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll, showsTraffic: false))
        .preferredColorScheme(.dark)
        // Tint the map slightly to keep focus on nodes
        .colorMultiply(Color(white: 0.8)) 
        .overlay(alignment: .bottomTrailing) {
            VStack {
                Text("Simulated offline data")
                    .font(.system(.caption, design: .default, weight: .regular))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

// Luminous pulsing pin
struct MapPinView: View {
    let node: LocationNode
    @State private var pulse: Bool = false
    
    var colorForVibe: Color {
        switch node.category {
        case .quiet: return .cyan
        case .highEnergy: return .red
        case .moderate: return .orange
        case .dining: return .green
        case .transit: return .gray
        }
    }
    
    var iconForVibe: String {
        switch node.category {
        case .quiet: return "book.fill"
        case .highEnergy: return "flame.fill"
        case .moderate: return "person.2.fill"
        case .dining: return "fork.knife"
        case .transit: return "bus.fill"
        }
    }
    
    var body: some View {
        ZStack {
            // Soft slow breathing pulse
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [colorForVibe.opacity(0.6), colorForVibe.opacity(0.0)]),
                        center: .center,
                        startRadius: 5,
                        endRadius: CGFloat(20 + (node.occupancyLevel * 30))
                    )
                )
                .frame(width: 80, height: 80)
                .scaleEffect(pulse ? 1.2 : 0.9)
                .animation(
                    Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: pulse
                )
            
            // Core node
            Circle()
                .fill(colorForVibe)
                .frame(width: 28, height: 28)
                .shadow(color: colorForVibe.opacity(0.8), radius: 8, x: 0, y: 0)
                .overlay {
                    Image(systemName: node.activeEvent != nil ? "star.fill" : iconForVibe)
                        .foregroundColor(node.activeEvent != nil ? .yellow : .white)
                        .font(.system(size: 10, weight: .bold))
                }
        }
        .onAppear {
            pulse = true
        }
        .onChange(of: node.occupancyLevel) { _ in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                pulse.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    pulse.toggle()
                }
            }
        }
    }
}
