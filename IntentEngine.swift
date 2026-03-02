import Foundation

enum UserIntent {
    case food
    case study
    case gym
    case emergencyAlcohol
    case emergencySeizure
    case stress
    case navigation(destination: String)
    case unknown
}

class IntentEngine {    
    static func parseIntent(from query: String) -> UserIntent {
        let q = query.lowercased()
        
        // Safety / Emergency
        if q.contains("drunk") || q.contains("passed out") || q.contains("alcohol") || q.contains("emergency") || q.contains("poisoning") || q.contains("help") || q.contains("sick") {
            return .emergencyAlcohol
        }
        if q.contains("seizure") || q.contains("convulsing") || q.contains("shaking") || q.contains("epilepsy") {
            return .emergencySeizure
        }
        
        // Mental Health / Stress
        if q.contains("stress") || q.contains("anxious") || q.contains("bad grades") || q.contains("panic") || q.contains("breathe") || q.contains("overwhelmed") || q.contains("sad") || q.contains("depressed") {
            return .stress
        }
        
        // Food / Dining
        if q.contains("hungry") || q.contains("hunger") || q.contains("eat") || q.contains("food") || q.contains("starving") || q.contains("dining") || q.contains("lunch") || q.contains("dinner") || q.contains("snack") || q.contains("breakfast") || q.contains("cravings") || q.contains("meal") || q.contains("grub") || q.contains("famished") {
            return .food
        }
        
        // Study / Quiet
        if q.contains("quiet") || q.contains("study") || q.contains("focus") || q.contains("library") || q.contains("homework") || q.contains("read") || q.contains("work") || q.contains("cram") || q.contains("exam") || q.contains("silence") || q.contains("peace") {
            return .study
        }
        
        // Gym / Recreation / Events
        if q.contains("basketball") || q.contains("gym") || q.contains("workout") || q.contains("hoops") || q.contains("swim") || q.contains("rec") || q.contains("fun") || q.contains("events") || q.contains("pop up") || q.contains("clubs") || q.contains("meetings") || q.contains("party") || q.contains("friends") || q.contains("hangout") || q.contains("activities") || q.contains("bored") || q.contains("social") || q.contains("music") || q.contains("free stuff") {
            return .gym // Maps to highEnergy and active spots
        }
        
        // Navigation / specific places
        if q.contains("how to get to") || q.contains("directions to") {
            return .navigation(destination: q)
        }
        
        return .unknown
    }
}
