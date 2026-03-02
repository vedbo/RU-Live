import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let protein: Int
}

struct MenuCategory {
    let name: String
    let items: [MenuItem]
}

struct MenuSheetView: View {
    let diningHallName: String
    @Environment(\.dismiss) var dismiss
    
    // Mock Data
    let menuCategories = [
        MenuCategory(name: "Grill", items: [
            MenuItem(name: "Grilled Chicken Breast", calories: 210, protein: 43),
            MenuItem(name: "Beyond Burger", calories: 350, protein: 20),
            MenuItem(name: "Turkey Bacon", calories: 90, protein: 6)
        ]),
        MenuCategory(name: "Market/Salad", items: [
            MenuItem(name: "Custom Salad Bowl", calories: 150, protein: 5),
            MenuItem(name: "Quinoa Salad", calories: 220, protein: 8),
            MenuItem(name: "Hard Boiled Eggs", calories: 140, protein: 12)
        ]),
        MenuCategory(name: "Hot Entrees", items: [
            MenuItem(name: "Brown Rice", calories: 170, protein: 4),
            MenuItem(name: "Steamed Broccoli", calories: 50, protein: 3),
            MenuItem(name: "Penne Marinara", calories: 280, protein: 9)
        ])
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Today's Macros").font(.headline).foregroundColor(.primary)) {
                    Text("Select items below to calculate macros (mock).")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                ForEach(menuCategories, id: \.name) { category in
                    Section(header: Text(category.name).font(.headline)) {
                        ForEach(category.items) { item in
                            HStack {
                                Text(item.name)
                                    .font(.subheadline)
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(item.calories) cal")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                    Text("\(item.protein)g protein")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("\(diningHallName) Menu")
            .navigationBarItems(trailing: Button("Close") { dismiss() })
        }
    }
}
