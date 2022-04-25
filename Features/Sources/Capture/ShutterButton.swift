import UIKit

class ShutterButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = isHighlighted ? .white.withAlphaComponent(0.7) : .white
        layer.cornerRadius = frame.width / 2.0
    }
}
