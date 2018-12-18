import UIKit

class BoardView: UIView {
    var board: TriangularArray<Tile>! {
        didSet {
            setNeedsDisplay()
        }
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
    
    func point(forCircleInRow row: Int, atIndex index: Int) -> CGPoint {
        let n = CGFloat(board.rowCount)
        let c = CGFloat(board.rowCount - row - 1)
        let w = bounds.width
        let h = bounds.height
        let x = (2 * w * CGFloat(index) + w * c) / (2 * n)
        let y = (n - c - 1) * h / n
        return CGPoint(x: x, y: y)
    }
}
