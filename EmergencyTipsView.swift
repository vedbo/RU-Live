import SwiftUI

struct EmergencyTipsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.red)
                    Text("Medical Safety Protocol")
                        .font(.system(.title, design: .default, weight: .bold))
                }
                .padding(.bottom, 8)
                
                Text("If someone has passed out from alcohol, **DO NOT LEAVE THEM ALONE**. Time is critical.")
                    .font(.system(.headline, design: .default, weight: .semibold))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 16) {
                    StepCard(step: "1", title: "Check Responses", description: "Pinch their arm or rub their sternum hard. If they do not wake up, it is a medical emergency.")
                    
                    StepCard(step: "2", title: "Recovery Position (B.A.C.K)", description: "Roll them onto their side so they don't choke on vomit. Prop their head up slightly. \n\nB - Bend the arm\nA - Angle the leg\nC - Carefully roll\nK - Keep airway clear")
                    
                    StepCard(step: "3", title: "Call for Help (911 / RUPD)", description: "Rutgers acts under the NJ Lifeline Legislation and the Good Samaritan policy. You and your friend will NOT get in trouble for underage drinking if you call for medical help.")
                }
                
                // Quick Call Actions
                VStack(spacing: 12) {
                    Button(action: {
                        // In a real device this would be: URL(string: "tel://911")
                    }) {
                        HStack {
                            Image(systemName: "phone.circle.fill")
                            Text("Call 911")
                        }
                        .font(.system(.title3, design: .default, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    
                    Button(action: {
                        // RUPD: 732-932-7211
                    }) {
                        HStack {
                            Image(systemName: "shield.fill")
                            Text("Call RUPD (732-932-7211)")
                        }
                        .font(.system(.headline, design: .default, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                }
                .padding(.top, 16)
                
            }
            .padding(24)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct StepCard: View {
    let step: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.2))
                    .frame(width: 40, height: 40)
                Text(step)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundColor(.red)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(.headline, design: .default, weight: .bold))
                    .foregroundColor(.white)
                Text(description)
                    .font(.system(.subheadline, design: .default, weight: .regular))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}
