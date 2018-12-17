import UIKit

class BoardView: UIView {
    var board: TriangularArray<Tile>! {
        didSet {
            setNeedsDisplay()
        }
    }
}
