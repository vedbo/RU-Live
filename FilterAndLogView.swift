import SwiftUI

struct FilterAndLogView: View {
    @EnvironmentObject var dataEngine: CampusDataEngine
    @State private var showingLogSheet = false
    
    var body: some View {
        HStack(spacing: 8) {
            // Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterButton(title: "All Vibes", icon: "map.fill", isSelected: dataEngine.selectedFilter == nil) {
                        withAnimation(.snappy) {
                            dataEngine.selectedFilter = nil
                        }
                    }
                    
                    ForEach(VibeCategory.allCases, id: \.self) { category in
                        FilterButton(title: category.rawValue, icon: iconFor(category), isSelected: dataEngine.selectedFilter == category) {
                            withAnimation(.snappy) {
                                dataEngine.selectedFilter = category
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            
            Spacer(minLength: 8)
            
            // Log Button
            Button(action: {
                showingLogSheet = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(dataEngine.selectedNode == nil ? Color.gray : Color.red)
                    .clipShape(Circle())
                    .shadow(color: dataEngine.selectedNode == nil ? .clear : Color.red.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .disabled(dataEngine.selectedNode == nil)
            .sheet(isPresented: $showingLogSheet) {
                if let node = dataEngine.selectedNode {
                    LogVibeSheet(node: node, isPresented: $showingLogSheet)
                        .environmentObject(dataEngine)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.15), radius: 16, x: 0, y: 8)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    func iconFor(_ category: VibeCategory) -> String {
        switch category {
        case .quiet: return "book.closed.fill"
        case .highEnergy: return "flame.fill"
        case .moderate: return "person.2.fill"
        case .dining: return "fork.knife"
        case .transit: return "bus.fill"
        }
    }
}

struct FilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.system(.subheadline, design: .default, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.white : Color.white.opacity(0.1))
            .foregroundColor(isSelected ? .black : .white)
            .cornerRadius(20)
        }
    }
}

struct LogVibeSheet: View {
    let node: LocationNode
    @Binding var isPresented: Bool
    @EnvironmentObject var dataEngine: CampusDataEngine
    
    @State private var selectedOccupancy: Double
    @State private var selectedVibe: VibeCategory
    
    init(node: LocationNode, isPresented: Binding<Bool>) {
        self.node = node
        self._isPresented = isPresented
        self._selectedOccupancy = State(initialValue: node.occupancyLevel)
        self._selectedVibe = State(initialValue: node.category)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Current Location")) {
                    Text(node.name)
                        .font(.headline)
                    Text(node.campus)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Update Occupancy (How crowded is it?)")) {
                    Slider(value: $selectedOccupancy, in: 0...1.0) {
                        Text("Occupancy")
                    }
                    Text("\(Int(selectedOccupancy * 100))% Full")
                        .foregroundColor(selectedOccupancy > 0.8 ? .red : .primary)
                }
                
                Section(header: Text("Update Vibe (What is the energy?)")) {
                    Picker("Vibe Category", selection: $selectedVibe) {
                        ForEach(VibeCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle("Log Your Pulse")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    dataEngine.logVibe(for: node, occupancy: selectedOccupancy, vibe: selectedVibe)
                    isPresented = false
                }
                .fontWeight(.bold)
            )
        }
        .presentationDetents([.medium, .large])
    }
}
