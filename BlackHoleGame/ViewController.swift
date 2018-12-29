import UIKit

class ViewController: UIViewController, BoardViewDelegate {

    var board: BoardView!
    let game = Game(boardSize: 7)
    var turn = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        board = BoardView(frame: CGRect(x: 10, y: 10, width: 300, height: 500))
        board.backgroundColor = .white
        board.board = game.board
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
        
        let color = game.currentTurn == .blue ? UIColor.blue : .red
        let number = game.currentNumber
        if game.makeMove(row: row, index: index) {
            self.board.addCircleViewAnimated(inRow: row,
                                             atIndex: index,
                                             backgroundColor: color,
                                             number: number,
                                             completion: { 
            self.board.board = self.game.board
    }
    
    func aiTurn() {
        self.board.board = self.game.board
        self.turn += 1
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else { return }
            let ai = GameAI(game: self.game, myColor: self.game.currentTurn)
            let move = ai.getNextMove(searchDepth: self.searchDepth(forTurn: self.turn))
            let aiNumber = self.game.currentNumber
            self.game.makeMove(row: move.row, index: move.index)
            self.board.appearAnimationForCircleView(
                inRow: move.row,
                atIndex: move.index,
                backgroundColor: ai.myColor == .blue ? .blue : .red,
                number: aiNumber).perform()
            
            self.turn += 1
        }
    }
}

