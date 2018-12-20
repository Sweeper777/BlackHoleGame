import UIKit

class BoardView: UIView {
    weak var delegate: BoardViewDelegate?
    
    var board: TriangularArray<Tile>! {
        didSet {
            setNeedsDisplay()
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
        return actualBoardFrame.height / CGFloat(board.rowCount)
    }
    
    override func draw(_ rect: CGRect) {
        if board == nil {
            return
        }
        
        let size = CGSize(width: circleDiameter, height: circleDiameter)
        for row in 0..<board.rowCount {
            for index in 0...row {
                let path = UIBezierPath(ovalIn: CGRect(origin: pointInViewFrame(forCircleInRow: row, atIndex: index), size: size))
                path.lineWidth = 3
                UIColor.black.setStroke()
                path.stroke()
            }
        }
        
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func pointInBoardFrame(forCircleInRow row: Int, atIndex index: Int) -> CGPoint {
        let n = CGFloat(board.rowCount)
        let c = CGFloat(board.rowCount - row - 1)
        let w = actualBoardFrame.width
        let h = actualBoardFrame.height
        let x = (2 * w * CGFloat(index) + w * c) / (2 * n)
        let y = (n - c - 1) * h / n
        return CGPoint(x: x, y: y)
    }
    
    func pointInViewFrame(forCircleInRow row: Int, atIndex index: Int) -> CGPoint {
        let point = pointInBoardFrame(forCircleInRow: row, atIndex: index)
        return CGPoint(x: point.x + actualBoardFrame.origin.x, y: point.y + actualBoardFrame.origin.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        let pointInBoardFrame = CGPoint(x: point.x - actualBoardFrame.origin.x, y: point.y - actualBoardFrame.origin.y)
        guard pointInBoardFrame.y >= 0 else { return }
        let touchedRow = Int(pointInBoardFrame.y / circleDiameter)
        let rowStart = self.pointInBoardFrame(forCircleInRow: touchedRow, atIndex: 0).x
        let rowEnd = self.pointInBoardFrame(forCircleInRow: touchedRow, atIndex: touchedRow).x + circleDiameter
        guard pointInBoardFrame.x >= rowStart && pointInBoardFrame.x <= rowEnd else { return }
        let touchedIndex = Int((pointInBoardFrame.x - rowStart) / circleDiameter)
        delegate?.didTouchCircle(inRow: touchedRow, atIndex: touchedIndex)
    }
    
    func addCircleView(at point: CGPoint, backgroundColor: UIColor, number: Int) {
        let circleView = CircleView(frame: CGRect(origin: point, size: CGSize(width: circleDiameter, height: circleDiameter)))
        circleView.backgroundColor = backgroundColor
        circleView.number = number
        self.addSubview(circleView)
    }
}
