import Foundation
import CoreLocation

// Define the type of vibe a location has
enum VibeCategory: String, CaseIterable, Identifiable {
    case quiet = "Quiet Study"
    case highEnergy = "High Energy"
    case moderate = "Moderate"
    case dining = "Dining"
    case transit = "Transit"
    
    var id: String { self.rawValue }
}

enum WifiStrength: String, CaseIterable, Identifiable {
    case excellent = "Excellent"
    case good = "Good"
    case poor = "Poor"
    
    var id: String { self.rawValue }
}

struct LocationNode: Identifiable, Equatable, Hashable {
    let id: UUID
    let name: String
    let campus: String
    let coordinate: CLLocationCoordinate2D
    var category: VibeCategory
    
    // Changing attributes
    var occupancyLevel: Double // 0.0 to 1.0 (empty to full)
    var noiseLevel: Double // 0 to 100 dB
    var activeEvent: String? // Optional event happening right now
    
    // Accessibility Suite attributes
    var isAccessible: Bool
    var accessibilityNotes: String?
    var isServiceAnimalFriendly: Bool
    var hasElevatorOutage: Bool
    var quietHours: String?
    
    // V6 Expansion features
    var wifiStrength: WifiStrength?
    var diningMenuUrl: URL?
    var nearbyTrains: [String]?
    var vibeRating: Double
    
    // Historical simulation data for charts
    var historicalOccupancy: [Double]
    
    init(id: UUID = UUID(), name: String, campus: String, coordinate: CLLocationCoordinate2D, category: VibeCategory, occupancyLevel: Double, noiseLevel: Double, activeEvent: String? = nil, isAccessible: Bool = true, accessibilityNotes: String? = nil, isServiceAnimalFriendly: Bool = true, hasElevatorOutage: Bool = false, quietHours: String? = nil, wifiStrength: WifiStrength? = nil, diningMenuUrl: URL? = nil, nearbyTrains: [String]? = nil, vibeRating: Double = 4.5) {
        self.id = id
        self.name = name
        self.campus = campus
        self.coordinate = coordinate
        self.category = category
        self.occupancyLevel = occupancyLevel
        self.noiseLevel = noiseLevel
        self.activeEvent = activeEvent
        self.isAccessible = isAccessible
        self.accessibilityNotes = accessibilityNotes
        self.isServiceAnimalFriendly = isServiceAnimalFriendly
        self.hasElevatorOutage = hasElevatorOutage
        self.quietHours = quietHours
        self.wifiStrength = wifiStrength
        self.diningMenuUrl = diningMenuUrl
        self.nearbyTrains = nearbyTrains
        self.vibeRating = vibeRating
        self.historicalOccupancy = Array(repeating: occupancyLevel, count: 24)
    }
    
    static func == (lhs: LocationNode, rhs: LocationNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@MainActor
class CampusDataEngine: ObservableObject {
    @Published var nodes: [LocationNode] = []
    @Published var selectedFilter: VibeCategory? = nil
    @Published var selectedNode: LocationNode? = nil
    
    private var timer: Timer?
    
    init() {
        setupInitialData()
        startSimulation()
    }
    
    func setupInitialData() {
        nodes = [
            // College Ave
            LocationNode(name: "Alexander Library", campus: "College Ave", coordinate: CLLocationCoordinate2D(latitude: 40.5015, longitude: -74.4485), category: .quiet, occupancyLevel: 0.6, noiseLevel: 30, accessibilityNotes: "Step-free entrance on College Ave side. Elevators near central hub.", hasElevatorOutage: true, quietHours: "Strict quiet hours past 8 PM", wifiStrength: .excellent, vibeRating: 4.8),
            LocationNode(name: "The Yard", campus: "College Ave", coordinate: CLLocationCoordinate2D(latitude: 40.4998, longitude: -74.4475), category: .highEnergy, occupancyLevel: 0.8, noiseLevel: 80, activeEvent: "Free Crumbl Cookies!", accessibilityNotes: "Fully accessible street-level pathways. Outdoor seating.", wifiStrength: .good, nearbyTrains: ["NJ Transit Express - 15m", "Amtrak Northeast - 45m"], vibeRating: 4.9),
            LocationNode(name: "Voorhees Mall", campus: "College Ave", coordinate: CLLocationCoordinate2D(latitude: 40.4997, longitude: -74.4468), category: .moderate, occupancyLevel: 0.4, noiseLevel: 45, isServiceAnimalFriendly: true, wifiStrength: .poor, vibeRating: 4.4),
            LocationNode(name: "The Atrium", campus: "College Ave", coordinate: CLLocationCoordinate2D(latitude: 40.5029, longitude: -74.4496), category: .dining, occupancyLevel: 0.9, noiseLevel: 75, wifiStrength: .good, diningMenuUrl: URL(string: "https://food.rutgers.edu"), vibeRating: 3.8),
            LocationNode(name: "College Ave Student Center Bus Stop", campus: "College Ave", coordinate: CLLocationCoordinate2D(latitude: 40.5026, longitude: -74.4504), category: .transit, occupancyLevel: 0.8, noiseLevel: 65, activeEvent: "LX Bus Arriving in 2m", wifiStrength: .excellent, vibeRating: 3.5),
            
            // Busch
            LocationNode(name: "Library of Science & Medicine", campus: "Busch", coordinate: CLLocationCoordinate2D(latitude: 40.5244, longitude: -74.4632), category: .quiet, occupancyLevel: 0.5, noiseLevel: 35, accessibilityNotes: "Elevator located near east wing.", quietHours: "Always quiet", wifiStrength: .excellent, vibeRating: 4.6),
            LocationNode(name: "Werblin Rec Center", campus: "Busch", coordinate: CLLocationCoordinate2D(latitude: 40.5218, longitude: -74.4589), category: .highEnergy, occupancyLevel: 0.7, noiseLevel: 85, accessibilityNotes: "Accessible locker rooms available.", wifiStrength: .good, vibeRating: 4.7),
            LocationNode(name: "Busch Dining Hall", campus: "Busch", coordinate: CLLocationCoordinate2D(latitude: 40.5230, longitude: -74.4646), category: .dining, occupancyLevel: 0.8, noiseLevel: 70, accessibilityNotes: "Access ramp installed at rear entrance.", wifiStrength: .excellent, diningMenuUrl: URL(string: "https://food.rutgers.edu/busch"), vibeRating: 4.1),
            LocationNode(name: "SHI Stadium", campus: "Busch", coordinate: CLLocationCoordinate2D(latitude: 40.5135, longitude: -74.4641), category: .highEnergy, occupancyLevel: 0.1, noiseLevel: 25, accessibilityNotes: "Designated wheelchair seating available.", hasElevatorOutage: false, wifiStrength: .poor, vibeRating: 4.9),
            LocationNode(name: "Hill Center Bus Stop", campus: "Busch", coordinate: CLLocationCoordinate2D(latitude: 40.5231, longitude: -74.4635), category: .transit, occupancyLevel: 0.5, noiseLevel: 50, wifiStrength: .good, vibeRating: 3.9),
            
            // Livi
            LocationNode(name: "James Dickson Carr Library", campus: "Livi", coordinate: CLLocationCoordinate2D(latitude: 40.5204, longitude: -74.4344), category: .quiet, occupancyLevel: 0.3, noiseLevel: 30, wifiStrength: .excellent, vibeRating: 4.5),
            LocationNode(name: "Rutgers Business School", campus: "Livi", coordinate: CLLocationCoordinate2D(latitude: 40.5213, longitude: -74.4326), category: .moderate, occupancyLevel: 0.6, noiseLevel: 55, accessibilityNotes: "Modern building, 100% ADA compliant with multiple elevators.", wifiStrength: .excellent, vibeRating: 4.9),
            LocationNode(name: "Livingston Dining Commons", campus: "Livi", coordinate: CLLocationCoordinate2D(latitude: 40.5208, longitude: -74.4385), category: .dining, occupancyLevel: 0.7, noiseLevel: 65, wifiStrength: .good, diningMenuUrl: URL(string: "https://food.rutgers.edu/livingston"), vibeRating: 4.5),
            LocationNode(name: "Jersey Mike's Arena", campus: "Livi", coordinate: CLLocationCoordinate2D(latitude: 40.5212, longitude: -74.4426), category: .highEnergy, occupancyLevel: 0.2, noiseLevel: 40, wifiStrength: .good, vibeRating: 4.8),
            LocationNode(name: "Ecological Preserve", campus: "Livi", coordinate: CLLocationCoordinate2D(latitude: 40.5140, longitude: -74.4370), category: .quiet, occupancyLevel: 0.1, noiseLevel: 20, isAccessible: false, accessibilityNotes: "Unpaved trails, steep inclines.", isServiceAnimalFriendly: true, wifiStrength: .poor, vibeRating: 4.7),
            
            // Cook/Douglass
            LocationNode(name: "Mabel Smith Douglass Library", campus: "Cook/Douglass", coordinate: CLLocationCoordinate2D(latitude: 40.4852, longitude: -74.4363), category: .quiet, occupancyLevel: 0.4, noiseLevel: 30, quietHours: "Quiet hours observed strictly after 6 PM", wifiStrength: .good, vibeRating: 4.4),
            LocationNode(name: "Neilson Dining Hall", campus: "Cook/Douglass", coordinate: CLLocationCoordinate2D(latitude: 40.4815, longitude: -74.4377), category: .dining, occupancyLevel: 0.6, noiseLevel: 60, wifiStrength: .good, diningMenuUrl: URL(string: "https://food.rutgers.edu/neilson"), vibeRating: 4.2),
            LocationNode(name: "Voorhees Chapel", campus: "Cook/Douglass", coordinate: CLLocationCoordinate2D(latitude: 40.4842, longitude: -74.4375), category: .moderate, occupancyLevel: 0.2, noiseLevel: 20, accessibilityNotes: "Ramp access at side entrance.", vibeRating: 4.8),
            LocationNode(name: "Red Oak Lane Bus Stop", campus: "Cook/Douglass", coordinate: CLLocationCoordinate2D(latitude: 40.4800, longitude: -74.4350), category: .transit, occupancyLevel: 0.3, noiseLevel: 45, wifiStrength: .poor, vibeRating: 3.2)
        ]
        
        generateRealisticHistory()
    }
    
    // Simulate initial realistic 24h history for charts
    private func generateRealisticHistory() {
        for i in 0..<nodes.count {
            for hour in 0..<24 {
                var baseOcc = nodes[i].occupancyLevel
                // Simulate daily cycle
                if hour >= 0 && hour < 7 {
                    baseOcc *= 0.1 // Night is dead
                } else if hour >= 10 && hour <= 14 {
                    baseOcc += 0.2 // Lunch rush
                } else if hour >= 18 && hour <= 21 {
                    baseOcc += (nodes[i].category == .dining || nodes[i].category == .highEnergy) ? 0.3 : 0.0 // Dinner / parties
                }
                nodes[i].historicalOccupancy[hour] = max(0.0, min(1.0, baseOcc + Double.random(in: -0.1...0.1)))
            }
        }
    }
    
    // The Data Challenge: Offline Simulated Timer
    private func startSimulation() {
        // Update nodes every 3 seconds to show live simulation
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.simulateChanges()
            }
        }
    }
    
    private func simulateChanges() {
        for i in 0..<nodes.count {
            // Pulse logic: randomly shift occupancy by +/- 5%
            let occShift = Double.random(in: -0.05...0.05)
            nodes[i].occupancyLevel = max(0.0, min(1.0, nodes[i].occupancyLevel + occShift))
            
            // Shift noise relative to occupancy
            let noiseShift = Double.random(in: -3.0...3.0)
            nodes[i].noiseLevel = max(20.0, min(100.0, nodes[i].noiseLevel + noiseShift))
            
            // Randomly spawn/remove events occasionally (5% chance)
            if Int.random(in: 1...20) == 1 {
                if nodes[i].activeEvent == nil {
                    if nodes[i].category == .highEnergy {
                        let events = ["Popup Concert!", "Free T-Shirts!", "Rush Event!", "Flash Mob!", "Watch Party!"]
                        nodes[i].activeEvent = events.randomElement()
                    } else if nodes[i].category == .dining {
                        let events = ["Midnight Breakfast!", "Steak Night!", "Cookie Popup!"]
                        nodes[i].activeEvent = events.randomElement()
                    }
                } else {
                    // Turn event off
                    nodes[i].activeEvent = nil
                }
            }
            
            // If the node we are editing is strictly selected, update selected node too
            if nodes[i].id == selectedNode?.id {
                selectedNode = nodes[i]
            }
        }
    }
    
    func logVibe(for node: LocationNode, occupancy: Double, vibe: VibeCategory) {
        if let index = nodes.firstIndex(where: { $0.id == node.id }) {
            nodes[index].occupancyLevel = occupancy
            nodes[index].category = vibe
            
            // "Save" to UserDefaults to demonstrate offline state persistence
            UserDefaults.standard.set(occupancy, forKey: "\(node.id)_occupancy")
            
            // Re-select if it was selected
            if selectedNode?.id == node.id {
                selectedNode = nodes[index]
            }
        }
    }
}
