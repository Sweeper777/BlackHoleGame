import UIKit
import SnapKit

class NextMoveView : UIView {
    @IBOutlet var circleView: CircleView!
    @IBOutlet var label: UILabel!
    
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
        
        label.adjustsFontSizeToFitWidth = true
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
    
    override func draw(_ rect: CGRect) {
        circleView.setNeedsDisplay()
    }
    
    func updateLabelFont() {
//        let fontSize = fontSizeThatFits(size: label.bounds.size, text: label.text! as NSString, font: label.font) * 0.7
//        let fontSize = label.height * 0.3
//        label.font = label.font.withSize(fontSize)
    }
}
