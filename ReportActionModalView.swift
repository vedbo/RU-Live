import SwiftUI

struct ReportActionModalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var reportText: String = ""
    @State private var selectedCategory: ReportCategory = .event
    @State private var isSubmitted: Bool = false
    
    enum ReportCategory: String, CaseIterable {
        case event = "Add Event"
        case issue = "Report Issue"
        case accessibility = "Accessibility Flag"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if isSubmitted {
                    VStack(spacing: 20) {
                        if #available(iOS 17.0, *) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.green)
                                .symbolEffect(.bounce, value: isSubmitted)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.green)
                        }
                        Text("Submitted to RU Live")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        Text("Your report helps keep the campus grid accurate for everyone.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 40)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Text("Help The Community")
                            .font(.system(.title, design: .default, weight: .bold))
                            .foregroundColor(.white)
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(ReportCategory.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 8)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(promptText)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            TextField(placeholderText, text: $reportText)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                isSubmitted = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                dismiss()
                            }
                        }) {
                            Text("Submit to Campus Grid")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(reportText.isEmpty ? Color.gray : Color.blue)
                                .cornerRadius(16)
                        }
                        .disabled(reportText.isEmpty)
                    }
                    .padding()
                }
            }
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
        .preferredColorScheme(.dark)
    }
    
    var promptText: String {
        switch selectedCategory {
        case .event: return "What's happening right now?"
        case .issue: return "Describe the campus issue..."
        case .accessibility: return "Report an accessibility barrier..."
        }
    }
    
    var placeholderText: String {
        switch selectedCategory {
        case .event: return "e.g. Free Crumbl Cookies at The Yard!"
        case .issue: return "e.g. Livi Dining Hall line is out the door"
        case .accessibility: return "e.g. Elevator out of service at ARC"
        }
    }
}
