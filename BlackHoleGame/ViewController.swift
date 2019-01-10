import UIKit
import SnapKit

class ViewController: UIViewController, BoardViewDelegate, GameDelegate {

    var aiQueue = DispatchQueue(label: "aiQueue")
    
    var board: BoardView!
    let game = Game(boardSize: 6)
    var turn = 1
    var nextMoveView: NextMoveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        board = BoardView(frame: CGRect(x: 10, y: 10, width: 300, height: 500))
        board.backgroundColor = .white
        board.board = game.board
        board.delegate = self
        game.delegate = self
        view.addSubview(board)
        
        nextMoveView = NextMoveView(frame: .zero)
        nextMoveView.color = .red
        nextMoveView.number = 1
        view.addSubview(nextMoveView)
        
        board.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(8)
        }
        
        nextMoveView.snp.makeConstraints { (make) in
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.height.equalToSuperview().dividedBy(8)
            make.width.equalToSuperview().dividedBy(8)
        }
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
            self.board.appearAnimationForCircleView(
                 inRow: row,
                 atIndex: index,
                 backgroundColor: color,
                 number: number
            ).do(block: aiTurn).perform()
        }
    }
    
    func gameDidEnd(game: Game, result: GameResult) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            let emptyIndex = game.board.indexOfEmpty()!
            self?.board.suckedInAnimation(toIndex: emptyIndex.1, atRow: emptyIndex.0).perform()
        }
    }
    
    func aiTurn() {
        self.board.board = self.game.board
        self.turn += 1
        aiQueue.async {
            [weak self] in
            guard let `self` = self else { return }
            let ai = GameAI(game: Game(copyOf: self.game), myColor: self.game.currentTurn)
            let move = ai.getNextMove(searchDepth: self.searchDepth(forTurn: self.turn))
            let aiNumber = self.game.currentNumber
            self.game.makeMove(row: move.row, index: move.index)
            self.board.board = self.game.board
            DispatchQueue.main.async {
                [weak self] in
                self?.board.appearAnimationForCircleView(
                    inRow: move.row,
                    atIndex: move.index,
                    backgroundColor: ai.myColor == .blue ? .blue : .red,
                    number: aiNumber).perform()
                
                self?.turn += 1
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        board.setNeedsDisplay()
        nextMoveView.setNeedsDisplay()
        nextMoveView.updateLabelFont()
        
    }
}

