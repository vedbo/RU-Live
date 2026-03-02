# 🔴 RU Live - Swift Student Challenge 2026

**RU Live** is a fully offline, neuro-inclusive campus companion app built entirely in Swift Playgrounds. It’s designed to transform overwhelming university environments (like Rutgers University) into accessible, safe, and manageable spaces for all students—especially those who are neurodivergent or dealing with sensory processing challenges.

By combining live (simulated offline) occupancy metrics, natural language intent parsing, and immediate accessibility resources, **RU Live** helps students navigate campus life with confidence.

---

## ✨ Key Features

### 🏛️ Real-Time Campus Simulation
- **Vibe Categories:** Every campus location is categorized by its sensory environment (e.g., *Quiet Study*, *High Energy*, *Transit*, *Dining*).
- **Dynamic Heatmap:** Fully interactive 3D map built with `MapKit` displaying live simulated occupancy and noise levels across all four Rutgers New Brunswick campuses.
- **Predictive Energy Trends:** Utilizes `Swift Charts` to generate a beautifully smooth, 24-hour gradient curve of expected foot traffic, so students can plan their day around their sensory needs.

### 🧠 Intent Engine (On-Device NLP)
- **Natural Language Command Processing:** A custom-built on-device parsing engine (`IntentEngine.swift`) that converts unstructured user text ("I'm starving", "Having a panic attack", "Need a quiet place to cram") into actionable routing and immediate emotional/physical support.

### ♿ Accessibility & Neuro-Inclusivity First
- **Sensory Awareness:** Clear tags for environments, highlighting places ideal for deep work and explicitly tagging overstimulating zones. 
- **Offline Transit Routing:** Provides localized, offline mock-estimates for inter-campus bus travel.
- **Critical Accessibility Tags:** Dynamic UI tracking ramp access, service animal friendliness, disabled-access elevator outages, and designated quiet hours.

### 🧘 Integrated Crisis & Wellness Tools
- **Box Breathing Guide (`BoxBreathingView.swift`):** Immediate, on-screen 4-4-4-4 breathing exercises utilizing recursive SwiftUI animations, designed to lower stress in overstimulating environments automatically. 
- **Safety Protocols:** One-tap emergency resources for severe situations like alcohol poisoning and seizure protocols.

---

## 🛠️ Built With...
- **SwiftUI:** Used for all declarative view building and rich aesthetic elements (`.ultraThinMaterial`, complex `.sheet` detents).
- **MapKit (`MapCameraPosition`):** Powers the core interactive visual interface.
- **Swift Charts:** Generates the dynamic historical timeline data. 
- **CoreLocation / Foundation:** Manages the geospatial coordinates and background data processing.
- **Swift Concurrency / Timers:** Powers the complex, persistent offline background simulation loops (`CampusDataEngine`).

---

## 📸 Screenshots

*(Add screenshots of your app here!)*

- **Screenshot 1:** The interactive 3D Map
- **Screenshot 2:** Detailed Vibe View showing Energy Trends and Accessibility
- **Screenshot 3:** The built-in Box Breathing wellness interface

---

## 🚀 Running the App

1. Download the `.swiftpm` folder.
2. Open it in **Swift Playgrounds 4.6+** (on Mac or iPad) or **Xcode 16+**.
3. Hit Run! 
*Note: The app relies entirely on local data simulation and does not require an active internet connection to demonstrate its core features.*

---

*Created for the 2026 Apple Swift Student Challenge.*
