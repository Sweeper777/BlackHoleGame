import UIKit

class CircleView: UIView {
    var number = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
}
