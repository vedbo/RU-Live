import SwiftUI
import Charts

struct DetailedVibeView: View {
    @EnvironmentObject var dataEngine: CampusDataEngine
    @State private var showMenuSheet = false
    @State private var hasReportedContextIssue = false
    @State private var hasReportedRamp = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let node = dataEngine.selectedNode {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(node.name)
                            .font(.system(.title, design: .default, weight: .semibold))
                        Text("\(node.campus) Campus")
                            .font(.system(.subheadline, design: .default, weight: .regular))
                            .foregroundColor(.secondary)
                        
                        // V6 Expansion: Rating & WiFi
                        HStack(spacing: 12) {
                            StarRatingView(rating: node.vibeRating)
                            
                            if let wifi = node.wifiStrength {
                                HStack(spacing: 4) {
                                    Image(systemName: "wifi")
                                    Text(wifi.rawValue)
                                }
                                .font(.caption.bold())
                                .foregroundColor(wifiColor(for: wifi))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(wifiColor(for: wifi).opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    }
                    
                    if let event = node.activeEvent {
                        HStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 16, weight: .bold))
                            Text("HAPPENING NOW: \(event)")
                                .font(.system(.subheadline, design: .default, weight: .bold))
                        }
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.yellow)
                        .cornerRadius(16)
                    }
                    
                    // Accessibility & Safety Tags
                    if node.isAccessible || node.isServiceAnimalFriendly || node.hasElevatorOutage || node.quietHours != nil {
                        VStack(spacing: 16) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    if node.isAccessible {
                                        AccessibilityTag(icon: "figure.roll", text: "Accessible", color: .blue)
                                    }
                                    if node.isServiceAnimalFriendly {
                                        AccessibilityTag(icon: "pawprint.fill", text: "Service Animals", color: .green)
                                    }
                                    if node.hasElevatorOutage {
                                        AccessibilityTag(icon: "exclamationmark.triangle.fill", text: "Elevator Outage", color: .red)
                                    }
                                    if let qh = node.quietHours {
                                        AccessibilityTag(icon: "clock.fill", text: qh, color: .purple)
                                    }
                                }
                            }
                            
                            // Community & Accessibility Action Buttons
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ActionButton(icon: "exclamationmark.bubble.fill", title: contextReportTitle(for: node.category), color: hasReportedContextIssue ? .gray : .orange) {
                                        withAnimation { hasReportedContextIssue = true }
                                    }
                                    
                                    if node.isAccessible {
                                        ActionButton(icon: "figure.roll", title: hasReportedRamp ? "Ramp Reported ✓" : "Report Blocked Ramp", color: hasReportedRamp ? .gray : .blue) {
                                            withAnimation { hasReportedRamp = true }
                                        }
                                    }
                                    
                                    ActionButton(icon: "phone.fill", title: "Call ODS", color: .purple) {
                                        if let url = URL(string: "tel://8484456800") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Live Stats
                    HStack(spacing: 16) {
                        StatBox(title: "Occupancy", value: String(format: "%.0f%%", node.occupancyLevel * 100), icon: "person.2.fill", color: .purple)
                        StatBox(title: "Noise Level", value: String(format: "%.0f dB", node.noiseLevel), icon: "waveform", color: .red)
                    }
                    
                    // Offline Mock Transit Logic
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "bus.fill")
                                .foregroundColor(.blue)
                            Text("Fastest Route")
                                .font(.system(.headline, design: .default, weight: .semibold))
                            Spacer()
                            Text(mockTransitTime(for: node.campus))
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        
                        Text(mockTransitInstructions(to: node.campus))
                            .font(.system(.subheadline, design: .default, weight: .regular))
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
                    // Contextual Accessibility Notes
                    if let notes = node.accessibilityNotes {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "figure.roll")
                                    .foregroundColor(.gray)
                                Text("Accessibility Notes")
                                    .font(.system(.headline, design: .default, weight: .semibold))
                            }
                            Text(notes)
                                .font(.system(.subheadline, design: .default, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: iconForVibe(node.category))
                                .foregroundColor(colorForVibe(node.category))
                            Text("Vibe: \(node.category.rawValue)")
                                .font(.system(.headline, design: .default, weight: .semibold))
                        }
                            
                        if node.category == .quiet {
                            Text("Low sensory environment. Ideal for deep work and neurodivergent individuals seeking quiet spaces.")
                                .font(.system(.caption, design: .default, weight: .regular))
                                .foregroundColor(.cyan)
                        } else if node.category == .highEnergy {
                            Text("High sensory environment. Expect loud noises, high sociability, and heavy foot traffic.")
                                .font(.system(.caption, design: .default, weight: .regular))
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Energy Trends")
                            .font(.system(.headline, design: .default, weight: .semibold))
                        
                        Chart {
                            ForEach(0..<24, id: \.self) { hour in
                                LineMark(
                                    x: .value("Hour", hour),
                                    y: .value("Energy", node.historicalOccupancy[hour])
                                )
                                .interpolationMethod(.catmullRom)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .foregroundStyle(Color.red.gradient)
                                
                                AreaMark(
                                    x: .value("Hour", hour),
                                    y: .value("Energy", node.historicalOccupancy[hour])
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.red.opacity(0.3), Color.red.opacity(0.0)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                        }
                        .frame(height: 220)
                        .chartXScale(domain: 0...23)
                        .chartYScale(domain: 0...1.0)
                        .chartXAxis {
                            AxisMarks(values: .automatic(desiredCount: 6)) { value in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                                AxisTick()
                                AxisValueLabel()
                            }
                        }
                        .chartYAxis {
                            AxisMarks() { _ in
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    
                    // V6 Expansion: Actionable Menus
                    if node.diningMenuUrl != nil {
                        Button(action: {
                            showMenuSheet = true
                        }) {
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("View Today's Menu & Macros")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(16)
                        }
                    }
                    
                    // V6 Expansion: Transit Departures
                    if let trains = node.nearbyTrains {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "tram.fill")
                                    .foregroundColor(.blue)
                                Text("Nearby Train Departures")
                                    .font(.system(.headline, design: .default, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            ForEach(trains, id: \.self) { train in
                                let parts = train.components(separatedBy: "-")
                                HStack {
                                    Text(parts[0].trimmingCharacters(in: .whitespaces))
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    if parts.count > 1 {
                                        Text(parts[1].trimmingCharacters(in: .whitespaces))
                                            .font(.subheadline.bold())
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(16)
                    }
                    
                } else {
                    VStack(spacing: 20) {
                        Group {
                            if #available(iOS 18.0, *) {
                                Image(systemName: "map.circle.fill")
                                    .font(.system(size: 80, weight: .ultraLight))
                                    .foregroundColor(.secondary)
                                    .symbolEffect(.breathe)
                            } else {
                                Image(systemName: "map.circle.fill")
                                    .font(.system(size: 80, weight: .ultraLight))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text("No Location Selected")
                            .font(.system(.title3, design: .default, weight: .semibold))
                        
                        Text("Select a node on the campus map to view real-time data and energy trends.")
                            .font(.system(.subheadline, design: .default, weight: .regular))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 60)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(24)
        }
        .sheet(isPresented: $showMenuSheet) {
            if let node = dataEngine.selectedNode {
                MenuSheetView(diningHallName: node.name)
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    // Helper colors
    func colorForVibe(_ category: VibeCategory) -> Color {
        switch category {
        case .quiet: return .cyan
        case .highEnergy: return .red
        case .moderate: return .orange
        case .dining: return .green
        case .transit: return .gray
        }
    }
    
    private func contextReportTitle(for category: VibeCategory) -> String {
        if hasReportedContextIssue { return "Reported ✓" }
        switch category {
        case .dining: return "Report Long Line"
        case .quiet: return "Report Noise Issue"
        case .highEnergy: return "Report Crowding"
        case .moderate: return "Report Issue"
        case .transit: return "Report Delay"
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
    
    func wifiColor(for strength: WifiStrength) -> Color {
        switch strength {
        case .excellent: return .green
        case .good: return .blue
        case .poor: return .orange
        }
    }
    
    // Mock Routing Helpers estimating from a generic central campus location (College Ave Student Center)
    func mockTransitInstructions(to campus: String) -> LocalizedStringKey {
        switch campus {
        case "College Ave":
            return "You are currently near College Ave. Walk via The Yard or Seminary Place. Traffic is light."
        case "Busch":
            return "Take the **A Route** (8 min peak) from College Ave Student Center or **H Route** (night owl). Drops off at ARC, Werblin, and Busch Student Center."
        case "Livi":
            return "Take the **LX Route** (Express, 5-15 min peak). Drops off at Livi Plaza, Livi Student Center, and Quads."
        case "Cook/Douglass":
            return "Take the **EE Route** (via George St) or **F Route** (Express via Rt 18). Key stops: Red Oak Lane, Lipman Hall, and College Hall."
        default:
            return "Head towards the closest campus bus stop. Check Passio GO for live times."
        }
    }
    
    func mockTransitTime(for campus: String) -> String {
        switch campus {
        case "College Ave": return "≈ 3 mins"
        case "Busch": return "≈ 12 mins"
        case "Livi": return "≈ 15 mins"
        case "Cook/Douglass": return "≈ 20 mins"
        default: return "≈ 10 mins"
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .font(.system(.subheadline, design: .default, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(color)
            .cornerRadius(8)
        }
    }
}

struct AccessibilityTag: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.system(size: 12, weight: .bold))
        .foregroundColor(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color.opacity(0.15))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}
struct StarRatingView: View {
    let rating: Double
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { index in
                Image(systemName: starType(for: index))
                    .foregroundColor(.yellow)
                    .font(.system(size: 14, weight: .bold))
            }
            Text(String(format: "%.1f", rating))
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundColor(.secondary)
                .padding(.leading, 4)
        }
    }
    
    private func starType(for index: Int) -> String {
        let filledStars = Int(rating)
        let hasHalfStar = rating - Double(filledStars) >= 0.5
        
        if index < filledStars {
            return "star.fill"
        } else if index == filledStars && hasHalfStar {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

