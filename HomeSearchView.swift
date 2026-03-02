import SwiftUI
import MapKit

struct HomeSearchView: View {
    @EnvironmentObject var dataEngine: CampusDataEngine
    
    @State private var searchText: String = ""
    @State private var isTextFieldFocused = false
    
    // Navigation Triggers
    @State private var navigateToMap = false
    @State private var navigateToBreathing = false
    @State private var navigateToSafety = false
    @State private var navigateToSeizure = false
    @State private var showReportSheet = false
    
    // Search State
    @State private var showSearchResults = false
    @State private var currentSearchIntent: UserIntent = .unknown
    @State private var currentSearchQuery: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Subtle glowing background
                Circle()
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 400, height: 400)
                    .blur(radius: 100)
                    .offset(x: -100, y: -200)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // Header with Accessibility Toggle
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("RU Live")
                                    .font(.system(size: 40, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                
                                Text("Your campus pulse. What do you need right now?")
                                    .font(.system(.title3, design: .default, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showReportSheet = true
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus.message.fill")
                                    Text("Report")
                                }
                                .font(.system(.subheadline, design: .default, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(20)
                            }
                            .accessibilityLabel("Report Issue or Add Event")
                        }
                        .padding(.top, 40)
                        
                        // Main Search Bar
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                TextField("e.g. 'I'm hungry', 'quiet spot', 'stressed'", text: $searchText)
                                    .foregroundColor(.white)
                                    .font(.system(.body, design: .default))
                                    .submitLabel(.search)
                                    .onSubmit {
                                        handleSearch()
                                    }
                                
                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            
                            Button(action: { handleSearch() }) {
                                Text("Find")
                                    .font(.system(.headline, design: .default, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .disabled(searchText.isEmpty)
                            .opacity(searchText.isEmpty ? 0.5 : 1.0)
                        }
                        
                        // Explicit Map Button
                        Button(action: {
                            dataEngine.selectedFilter = nil
                            navigateToMap = true
                        }) {
                            HStack {
                                Image(systemName: "map.fill")
                                    .font(.system(size: 20))
                                Text("Open Full Campus Map")
                                    .font(.system(.headline, design: .default, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                        
                        // Siri-like Intent Chips
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quick Actions")
                                .font(.system(.headline, design: .default, weight: .semibold))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                IntentChip(icon: "fork.knife", title: "Dine Off-Peak", subtitle: "Find dining halls with space right now", color: .green) {
                                    searchText = "hungry"
                                    handleSearch()
                                }
                                
                                IntentChip(icon: "book.closed.fill", title: "Deep Focus", subtitle: "Locate quiet spaces on campus", color: .cyan) {
                                    searchText = "quiet"
                                    handleSearch()
                                }
                                
                                IntentChip(icon: "figure.run", title: "Hit the Gym", subtitle: "Find active places to workout", color: .orange) {
                                    searchText = "gym"
                                    handleSearch()
                                }
                                
                                IntentChip(icon: "lungs.fill", title: "Take a Breather", subtitle: "Box breathing exercises for stress", color: .blue) {
                                    searchText = "stressed"
                                    handleSearch()
                                }
                                
                                IntentChip(icon: "cross.case.fill", title: "Emergency Help", subtitle: "Alcohol safety or urgent assistance", color: .red) {
                                    searchText = "emergency"
                                    handleSearch()
                                }
                                
                                IntentChip(icon: "staroflife.fill", title: "Seizure Protocol", subtitle: "Critical epilepsy medical guide", color: .purple) {
                                    searchText = "seizure"
                                    handleSearch()
                                }
                                
                                IntentChip(icon: "bus.fill", title: "Campus Transit", subtitle: "Live RU bus routes & times", color: .gray) {
                                    searchText = "bus"
                                    handleSearch()
                                }
                            }
                        }
                        
                    }
                    .padding(24)
                }
            }
            .navigationDestination(isPresented: $showSearchResults) {
                SearchResultsView(intent: currentSearchIntent, query: currentSearchQuery)
            }
            .navigationDestination(isPresented: $navigateToMap) {
                if #available(iOS 17.0, *) {
                    MapDashboardContainer()
                } else {
                    Text("Map requires iOS 17.0 or later")
                        .foregroundColor(.white)
                }
            }
            .navigationDestination(isPresented: $navigateToBreathing) {
                BoxBreathingView()
                    .navigationTitle("Stress Relief")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationDestination(isPresented: $navigateToSafety) {
                EmergencyTipsView()
                    .navigationTitle("Safety")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationDestination(isPresented: $navigateToSeizure) {
                SeizureProtocolView()
                    .navigationTitle("Seizure Protocol")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(isPresented: $showReportSheet) {
            ReportActionModalView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // Core Offline Routing Logic
    func handleSearch() {
        guard !searchText.isEmpty else { return }
        let intent = IntentEngine.parseIntent(from: searchText)
        
        switch intent {
        case .emergencyAlcohol:
            navigateToSafety = true
        case .emergencySeizure:
            navigateToSeizure = true
        case .stress:
            navigateToBreathing = true
        default:
            currentSearchIntent = intent
            currentSearchQuery = searchText
            showSearchResults = true
        }
        
        searchText = ""
    }
}

struct SearchResultsView: View {
    @EnvironmentObject var dataEngine: CampusDataEngine
    let intent: UserIntent
    let query: String
    
    var filteredNodes: [LocationNode] {
        var results: [LocationNode] = []
        switch intent {
        case .food:
            results = dataEngine.nodes.filter { $0.category == .dining }.sorted { $0.occupancyLevel < $1.occupancyLevel }
        case .study:
            results = dataEngine.nodes.filter { $0.category == .quiet }.sorted { $0.noiseLevel < $1.noiseLevel }
        case .gym:
            results = dataEngine.nodes.filter { $0.category == .highEnergy }.sorted { $0.occupancyLevel < $1.occupancyLevel }
        default:
            // Fallback: simple text match on names
            results = dataEngine.nodes.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
        
        // Never show nothing - if no matches, return all nodes ranked by excitement (occupancy)
        if results.isEmpty {
            return dataEngine.nodes.sorted { $1.occupancyLevel < $0.occupancyLevel }
        }
        
        return results
    }
    
    var pageTitle: String {
        switch intent {
        case .food: return "Dining Options"
        case .study: return "Quiet Study Spots"
        case .gym: return "Active Locations"
        default: return filteredNodes.count == dataEngine.nodes.count ? "Top Campus Spots" : "Search Results"
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(pageTitle)
                        .font(.system(.largeTitle, design: .default, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.horizontal)
                    
                    if filteredNodes.count == dataEngine.nodes.count {
                        Text("We couldn't find an exact match for '\(query)', but here are the most active spots on campus right now:")
                            .font(.system(.subheadline, design: .default, weight: .regular))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    ForEach(filteredNodes) { node in
                        Button(action: {
                            dataEngine.selectedNode = node
                        }) {
                            ResultTile(node: node)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 40)
            }
        }
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

struct ResultTile: View {
    let node: LocationNode
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(colorForVibe(node.category).opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: iconForVibe(node.category))
                    .foregroundColor(colorForVibe(node.category))
                    .font(.system(size: 24, weight: .bold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(node.name)
                    .font(.system(.headline, design: .default, weight: .bold))
                    .foregroundColor(.white)
                Text("\(node.campus) Campus")
                    .font(.system(.subheadline, design: .default, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Mini stat
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 10))
                    Text(String(format: "%.0f%%", node.occupancyLevel * 100))
                        .font(.system(.caption, design: .rounded, weight: .bold))
                }
                .foregroundColor(.purple)
                
                if node.activeEvent != nil {
                    Text("LIVE")
                        .font(.system(size: 10, weight: .black))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(4)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
    
    // Duplicated helpers for quick standalone UI rendering
    func colorForVibe(_ category: VibeCategory) -> Color {
        switch category {
        case .quiet: return .cyan
        case .highEnergy: return .red
        case .moderate: return .orange
        case .dining: return .green
        case .transit: return .gray
        }
    }
    func iconForVibe(_ category: VibeCategory) -> String {
        switch category {
        case .quiet: return "book.fill"
        case .highEnergy: return "flame.fill"
        case .moderate: return "person.2.fill"
        case .dining: return "fork.knife"
        case .transit: return "bus.fill"
        }
    }
}

// Container to wrap the existing MapDashboard sheet logic
@available(iOS 17.0, *)
struct MapDashboardContainer: View {
    @EnvironmentObject var dataEngine: CampusDataEngine
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 40.5218, longitude: -74.4589), // Default Center Busch
            distance: 8000,
            pitch: 0
        )
    )
    
    var body: some View {
        ZStack(alignment: .top) {
            MapDashboardView(cameraPosition: $cameraPosition)
            
            FilterAndLogView()
                .padding()
        }
        .navigationTitle("Campus Map")
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

struct IntentChip: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(.headline, design: .default, weight: .semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(.subheadline, design: .default, weight: .regular))
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
        }
    }
}
