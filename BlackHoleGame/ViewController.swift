import UIKit

class ViewController: UIViewController, BoardViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let board = BoardView(frame: CGRect(x: 10, y: 10, width: 300, height: 500))
        board.backgroundColor = .white
        board.board = Game().board
        board.delegate = self
        view.addSubview(board)
    }
    
    func didTouchCircle(inRow row: Int, atIndex index: Int) {
        print("Touched: row \(row), index \(index)")
    }
}

