import UIKit
import SwiftyAnimate

class CircleView: UIView {
    var number: Int? = 1 {
        didSet {
            if let number = self.number {
                let fontSize = fontSizeThatFits(size: bounds.size, text: "\(number)" as NSString, font: UIFont.systemFont(ofSize: 0)) * 0.7
                label?.font = UIFont.systemFont(ofSize: fontSize)
                label?.text = "\(number)"
            } else {
                label?.text = ""
            }
        }
    }
    
    var label: UILabel!
    
    var circleColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if bounds.height > bounds.width {
            let y = (bounds.height - bounds.width) / 2
            let path = UIBezierPath(ovalIn: CGRect(x: 0, y: y, width: bounds.width, height: bounds.width))
            circleColor.setFill()
            path.fill()
        } else {
            let x = (bounds.width - bounds.height) / 2
            let path = UIBezierPath(ovalIn: CGRect(x: x, y: 0, width: bounds.height, height: bounds.height))
            circleColor.setFill()
            path.fill()
        }
        if let number = self.number {
            let fontSize = fontSizeThatFits(size: bounds.size, text: "\(number)" as NSString, font: UIFont.systemFont(ofSize: 0)) * 0.7
            label?.font = UIFont.systemFont(ofSize: fontSize)
            label?.text = "\(number)"
        } else {
            label?.text = ""
        }
    }

    func commonInit() {
        label = UILabel(frame: .zero)
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        isUserInteractionEnabled = false
        clipsToBounds = true
        label.textColor = .white
        label.textAlignment = .center
        backgroundColor = .clear
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
            .then(animation: scaled(duration: 0.3, x: 1.2, y: 1.2))
            .then(animation: scaled(duration: 0.1, x: 1, y: 1))
    }
    
    func suckedIn(x: CGFloat, y: CGFloat) -> Animate {
        return Animate()
            .and(animation: transform(duration: 1, transforms:
                [.move(x: x - self.x, y: y - self.y),
                 .scale(x: 0.01, y: 0.01)], options: [.curveEaseIn]))
        
    }
}
