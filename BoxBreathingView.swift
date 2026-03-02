import SwiftUI

struct BoxBreathingView: View {
    @State private var scale: CGFloat = 0.5
    @State private var breathingText: String = "Breathe In"
    @State private var isAnimating: Bool = false
    
    // 4-4-4-4 Box Breathing timing
    let duration: Double = 4.0
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 60) {
                Text(breathingText)
                    .font(.system(size: 32, weight: .light, design: .rounded))
                    .foregroundColor(.white)
                    .animation(.easeInOut(duration: 0.5), value: breathingText)
                
                ZStack {
                    // Outer structural ring
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 2)
                        .frame(width: 300, height: 300)
                    
                    // Breathing luminous ring
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.cyan.opacity(0.8), Color.cyan.opacity(0.0)]),
                                center: .center,
                                startRadius: 10,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .scaleEffect(scale)
                        .shadow(color: Color.cyan.opacity(0.6), radius: 30 * scale)
                }
                
                Text("Box breathing resets your autonomic nervous system and lowers stress immediately.")
                    .font(.system(.subheadline, design: .default, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .onAppear {
            startBreathingCycle()
        }
    }
    
    func startBreathingCycle() {
        guard !isAnimating else { return }
        isAnimating = true
        
        // Initial setup
        scale = 0.5
        breathingText = "Breathe In..."
        
        // Cycle manager
        runCycle()
    }
    
    func runCycle() {
        // Breathe In
        withAnimation(.easeInOut(duration: duration)) {
            scale = 1.0
        }
        breathingText = "Breathe In..."
        
        // Hold
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.breathingText = "Hold..."
            
            // Breathe Out
            DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
                withAnimation(.easeInOut(duration: self.duration)) {
                    self.scale = 0.5
                }
                self.breathingText = "Breathe Out..."
                
                // Hold Empty
                DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
                    self.breathingText = "Hold..."
                    
                    // Loop
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
                        self.runCycle()
                    }
                }
            }
        }
    }
}
