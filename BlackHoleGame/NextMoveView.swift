import UIKit

class NextMoveView : UIView {
    @IBOutlet var circleView: CircleView!
    
    var number: Int? {
        didSet {
            circleView.number = number
        }
    }
    
    var color: UIColor = .clear {
        didSet {
            circleView.backgroundColor = color
        }
    }
    
}
