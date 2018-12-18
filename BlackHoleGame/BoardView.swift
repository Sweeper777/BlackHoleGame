import UIKit

class BoardView: UIView {
    var board: TriangularArray<Tile>! {
        didSet {
            setNeedsDisplay()
        }
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
