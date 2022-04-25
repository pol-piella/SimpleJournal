import UIKit

protocol Feedback {
    func perform()
}

class Haptic: Feedback {
    let generator = UIFeedbackGenerator()
    
    func perform() {
        generator.prepare()
    }
}
