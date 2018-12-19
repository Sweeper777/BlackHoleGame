import UIKit

class BoardView: UIView {
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
        
        let size = CGSize(width: bounds.width / CGFloat(board.rowCount), height: bounds.height / CGFloat(board.rowCount))
        for row in 0..<board.rowCount {
            for index in 0..<row {
                let path = UIBezierPath(ovalIn: CGRect(origin: point(forCircleInRow: row, atIndex: index), size: size))
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
    
}
