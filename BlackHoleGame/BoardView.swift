import UIKit
import SwiftyUtils
import SwiftyAnimate

class BoardView: UIView {
    weak var delegate: BoardViewDelegate?
    
    var board: TriangularArray<Tile>! {
        didSet {
//            setNeedsDisplay()
        }
    }
    
    var actualBoardFrame: CGRect {
        if bounds.width < bounds.height {
            return CGRect(x: 0,
                          y: (bounds.height - bounds.width) / 2,
                          width: bounds.width,
                          height: bounds.width)
                .insetBy(dx: 3, dy: 3)
        } else {
            return CGRect(x: (bounds.width - bounds.height) / 2,
                          y: 0,
                          width: bounds.height,
                          height: bounds.height)
                .insetBy(dx: 3, dy: 3)
        }
    }
    
    var circleDiameter: CGFloat {
        return actualBoardFrame.height / board.rowCount.f
    }
    
    override func draw(_ rect: CGRect) {
        if board == nil {
            return
        }
        
        self.subviews.forEach { $0.removeFromSuperview() }
        let size = CGSize(width: circleDiameter, height: circleDiameter)
        for row in 0..<board.rowCount {
            for index in 0...row {
                let path = UIBezierPath(ovalIn: CGRect(origin: pointInViewFrame(forCircleInRow: row, atIndex: index), size: size))
                path.lineWidth = 3
                UIColor.black.setStroke()
                path.stroke()
                
                let tile = board[row, index]!
                switch tile {
                case .empty:
                    break
                case .red(let number):
                    addCircleView(inRow: row,
                                  atIndex: index,
                                  backgroundColor: .red,
                                  number: number)
                case .blue(let number):
                    addCircleView(inRow: row,
                                  atIndex: index,
                                  backgroundColor: .blue,
                                  number: number)
                }
            }
        }
        
    }
    
    func pointInBoardFrame(forCircleInRow row: Int, atIndex index: Int) -> CGPoint {
        let n = board.rowCount.f
        let c = (board.rowCount - row - 1).f
        let w = actualBoardFrame.width
        let h = actualBoardFrame.height
        let x = (2 * w * index.f + w * c) / (2 * n)
        let y = (n - c - 1) * h / n + (c * (circleDiameter / 2) * tan(.pi / 12))
        return CGPoint(x: x, y: y)
    }
    
    func pointInViewFrame(forCircleInRow row: Int, atIndex index: Int) -> CGPoint {
        let point = pointInBoardFrame(forCircleInRow: row, atIndex: index)
        return CGPoint(x: point.x + actualBoardFrame.origin.x, y: point.y + actualBoardFrame.origin.y)
    }
    
    func frameForCircleView(inRow row: Int, atIndex index: Int) -> CGRect {
        let transform = CGAffineTransform(translationX: 1.5, y: 1.5)
        let point = pointInViewFrame(forCircleInRow: row, atIndex: index).applying(transform)
        let size = CGSize(width: circleDiameter - 3, height: circleDiameter - 3)
        return CGRect(origin: point, size: size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        let pointInBoardFrame = CGPoint(x: point.x - actualBoardFrame.origin.x, y: point.y - actualBoardFrame.origin.y)
        let R = circleDiameter / 2
        let transform = CGAffineTransform(translationX: R, y: R)
        let s3 = sqrt(3).f
        let centerOfFirstCircle = self.pointInBoardFrame(forCircleInRow: 0, atIndex: 0).applying(transform)
        let x = pointInBoardFrame.x - centerOfFirstCircle.x
        let y = pointInBoardFrame.y - centerOfFirstCircle.y
        let denominator = 2*R*s3
        let a = -x / (2*R) + y / denominator
        let b = x / (2*R) +  y / denominator
        let touchedRow = (Int(a.rounded()) + Int(b.rounded()))
        let touchedIndex = Int(b.rounded())
        delegate?.didTouchCircle(inRow: touchedRow, atIndex: touchedIndex)
    }
    
    func addCircleView(inRow row: Int, atIndex index: Int, backgroundColor: UIColor, number: Int) {
        let circleView = CircleView(frame: frameForCircleView(inRow: row, atIndex: index))
        circleView.backgroundColor = backgroundColor
        circleView.number = number
        self.addSubview(circleView)
    }
    
    func addCircleViewAnimated(inRow row: Int, atIndex index: Int, backgroundColor: UIColor, number: Int, completion: @escaping () -> Void) {
        let circleView = CircleView(frame: frameForCircleView(inRow: row, atIndex: index))
        circleView.backgroundColor = backgroundColor
        circleView.number = number
        circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.addSubview(circleView)
//        Animation.animate(identifier: "appear", duration: 0.7) { (progress) -> Bool in
//            circleView.transform = CGAffineTransform(scaleX: 0, y: 0) <~~ Curve.parabolicBounce[progress] ~~> CGAffineTransform.identity
//            return true
//        }
        UIView.animate(withDuration: 0.3, animations: {
            circleView.transform = .identity
        }, completion: { _ in completion() })
    }
}
