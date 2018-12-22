import UIKit

class ViewController: UIViewController, BoardViewDelegate {

    var board: BoardView!
    let game = Game()
    var turn = 1
    
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
        if game.currentTurn != .red || game.checkWin() != .undecided {
            return
        }
        
        game.makeMove(row: row, index: index)
        board.board = game.board
        turn += 1
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else { return }
            let ai = GameAI(game: self.game, myColor: self.game.currentTurn)
            let move = ai.getNextMove(searchDepth: self.searchDepth(forTurn: self.turn))
            self.game.makeMove(row: move.row, index: move.index)
            self.board.board = self.game.board
            self.turn += 1
        }
    }
}

