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
    
    func commonInit() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        backgroundColor = .clear
    }
}
