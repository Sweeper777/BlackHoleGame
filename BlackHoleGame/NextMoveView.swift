import UIKit
import SnapKit

class NextMoveView : UIView {
    @IBOutlet var circleView: CircleView!
    
    var number: Int? {
        didSet {
            circleView.number = number
        }
    }
    
    var color: UIColor = .clear {
        didSet {
            circleView.circleColor = color
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
    
    private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle(for: NextMoveView.self)
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
