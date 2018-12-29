import UIKit
import SwiftyAnimate

class CircleView: UILabel {
    var number = 1 {
        didSet {
            let fontSize = fontSizeThatFits(size: bounds.size, text: "\(number)" as NSString, font: UIFont.systemFont(ofSize: 0)) * 0.7
            font = UIFont.systemFont(ofSize: fontSize)
            text = "\(number)"
        }
    }

    func commonInit() {
        layer.cornerRadius = bounds.width / 2
        isUserInteractionEnabled = false
        clipsToBounds = true
        textColor = .white
        textAlignment = .center
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

extension CircleView {
    func appear() -> Animate {
        return Animate()
            .then(animation: scaled(duration: 0.3, x: 1.1, y: 1.1))
            .then(animation: scaled(duration: 0.1, x: 1, y: 1))
    }
}
