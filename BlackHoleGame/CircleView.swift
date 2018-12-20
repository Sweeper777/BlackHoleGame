import UIKit

class CircleView: UIView {
    var number = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func commonInit() {
        layer.cornerRadius = bounds.width / 2
        isUserInteractionEnabled = false
        clipsToBounds = true
    }
    
}
