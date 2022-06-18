import UIKit

protocol Feedback {
    func perform()
}

class Haptic: Feedback {
    let generator = UISelectionFeedbackGenerator()
    
    func perform() {
        generator.selectionChanged()
    }
}
