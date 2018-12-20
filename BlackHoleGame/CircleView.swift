import UIKit

class CircleView: UIView {
    var number = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let fontSize = fontSizeThatFits(size: bounds.size, text: "\(number)" as NSString, font: UIFont.systemFont(ofSize: 0)) * 0.7
        let font = UIFont.systemFont(ofSize: fontSize)
        ("\(number)" as NSString).draw(in: bounds,
                                       withAttributes: [.font: font, .foregroundColor: UIColor.white])
        
    }
    
    func commonInit() {
        layer.cornerRadius = bounds.width / 2
        isUserInteractionEnabled = false
        clipsToBounds = true
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
