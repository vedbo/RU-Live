import SwiftUI

struct SeizureProtocolView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // High contrast medical background
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    HStack {
                        Image(systemName: "cross.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading) {
                            Text("Seizure Protocol")
                                .font(.system(.title, design: .default, weight: .bold))
                                .foregroundColor(.white)
                            Text("Offline Medical Information")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Critical Alert
                    VStack(alignment: .leading, spacing: 12) {
                        Text("DO NOT RESTRAIN. DO NOT PUT ANYTHING IN THEIR MOUTH.")
                            .font(.system(.headline, design: .default, weight: .black))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(12)
                    }
                    
                    // Steps
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Immediate Actions")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        StepCard(step: "1", title: "Time The Seizure", description: "Look at your watch. If the active seizing lasts longer than 5 minutes, call 911 immediately.")
                        
                        StepCard(step: "2", title: "Clear The Space", description: "Move hard or sharp objects away. Guide them to the floor if seated.")
                        
                        StepCard(step: "3", title: "Protect The Head", description: "Place something soft and flat, like a folded jacket, under their head.")
                        
                        StepCard(step: "4", title: "Recovery Position", description: "Once the shaking stops, gently roll them onto their side to keep their airway clear.")
                    }
                    
                    // Medical ID Checking
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Check Medical ID")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        Text("Check the person's lock screen or Apple Watch for an Emergency Medical ID which may list Epilepsy instructions.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            if let url = URL(string: "x-apple-health://MedicalID") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "heart.text.square.fill")
                                Text("Open My Medical ID")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(16)
                        }
                    }
                    .padding(.top, 8)
                    
                    // Emergency Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("When to call Emergency Services")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            BulletPoint(text: "The seizure lasts longer than 5 minutes.")
                            BulletPoint(text: "They have a second seizure immediately after.")
                            BulletPoint(text: "They are having trouble breathing after the seizure.")
                            BulletPoint(text: "They are injured or in water.")
                            BulletPoint(text: "It is their first ever seizure.")
                        }
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if let url = URL(string: "tel://911") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text("Call 911")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(16)
                            }
                            
                            Button(action: {
                                if let url = URL(string: "tel://7329327211") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "shield.fill")
                                    Text("RUPD")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.top, 16)
                }
                .padding()
            }
        }
    }
}

// Reusing existing visual components
private struct BulletPoint: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .fontWeight(.bold)
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

