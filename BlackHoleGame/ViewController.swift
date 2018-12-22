import UIKit

class ViewController: UIViewController, BoardViewDelegate {

    var board: BoardView!
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        board = BoardView(frame: CGRect(x: 10, y: 10, width: 300, height: 500))
        board.backgroundColor = .white
        board.board = Game().board
        board.delegate = self
        view.addSubview(board)
    }
    
    func searchDepth(forTurn turn: Int) -> Int {
        if turn < 10 {
            return 3
        }
        if turn < 14 {
            return 4
        }
        return 6
    }
    
    func didTouchCircle(inRow row: Int, atIndex index: Int) {
        game.makeMove(row: row, index: index)
        board.board = game.board
    }
}

