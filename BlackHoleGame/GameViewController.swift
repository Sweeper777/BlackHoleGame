import UIKit
import SnapKit
import SwiftyButton
import SCLAlertView

class GameViewController: UIViewController, BoardViewDelegate, GameDelegate {

    var aiQueue = DispatchQueue(label: "aiQueue")
    
    var board: BoardView!
    var restartButton: PressableButton!
    var quitButton: PressableButton!
    var nextMoveView: NextMoveView!
    
    var game = Game(boardSize: 6)
    var turn = 1
    var myColor: PlayerSide!
    
    var constraintRelativeToHeight: Constraint!
    var constraintRelativeToWidth: Constraint!
    
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
        
        addConstraintsForNextMoveView()
        
        quitButton = PressableButton()
        quitButton.setTitle("╳", for: .normal)
        view.addSubview(quitButton)
        quitButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(8)
            make.width.equalTo(quitButton.snp.height)
            make.height.equalTo(nextMoveView.snp.width).dividedBy(2)
        }
        quitButton.addTarget(self, action: #selector(quitButtonDidPress), for: .touchUpInside)
        
        restartButton = PressableButton()
        restartButton.setTitle("↺", for: .normal)
        view.addSubview(restartButton)
        restartButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(quitButton.snp.top).offset(-8)
            make.left.equalToSuperview().inset(8)
            make.width.equalTo(restartButton.snp.height)
            make.height.equalTo(nextMoveView.snp.width).dividedBy(2)
        }
        restartButton.addTarget(self, action: #selector(restartButtonDidPress), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        restartButton.titleLabel!.updateFontSizeToFit(size: restartButton.bounds.size)
        quitButton.titleLabel!.updateFontSizeToFit(size: quitButton.bounds.size)
        nextMoveView.label.updateFontSizeToFit()
        updateNextMoveViewConstraints()
    }
    
    func addConstraintsForNextMoveView() {
        nextMoveView.snp.makeConstraints { (make) in
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.width.equalTo(nextMoveView.snp.height).dividedBy(1.2)
            constraintRelativeToHeight = make.height.equalTo(view.snp.height).dividedBy(7).constraint
            constraintRelativeToWidth = make.width.equalTo(view.snp.width).dividedBy(7).constraint
        }
    }
    
    func updateNextMoveViewConstraints() {
        if traitCollection.horizontalSizeClass == .compact &&
            traitCollection.verticalSizeClass == .regular {
            constraintRelativeToWidth.deactivate()
            constraintRelativeToHeight.activate()
        } else {
            constraintRelativeToWidth.activate()
            constraintRelativeToHeight.deactivate()
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
        if game.currentTurn != .red || game.ended{
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
            updateNextMoveView()
        }
    }
    
    func gameDidEnd(game: Game, result: GameResult) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            [weak self] in
            let emptyIndex = game.board.indexOfEmpty()!
            self?.board.suckedInAnimation(toIndex: emptyIndex.1, atRow: emptyIndex.0).perform {
                let alert = SCLAlertView()
                switch result {
                case .blueWins(red: let red, blue: let blue):
                    alert.showInfo("Blue won!", subTitle: "Red: \(red), Blue: \(blue)")
                case .redWins(red: let red, blue: let blue):
                    alert.showInfo("Red won!", subTitle: "Red: \(red), Blue: \(blue)")
                case .draw(both: let both):
                    alert.showInfo("It's a draw!", subTitle: "Red: \(both), Blue: \(both)")
                case .undecided:
                    fatalError("This should not be reached")
                }
            }
        }
    }
    
    func aiTurn() {
        self.board.board = self.game.board
        self.turn += 1
        aiQueue.async {
            [weak self] in
            guard let `self` = self else { return }
            let ai = HeuristicAI(game: Game(copyOf: self.game), myColor: self.game.currentTurn)
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
                self?.updateNextMoveView()
            }
        }
    }
    
    func updateNextMoveView() {
        nextMoveView.color = game.currentTurn == .red ? .red : .blue
        nextMoveView.number = game.ended ? nil :  game.currentNumber
    }
    
    @objc func restartButtonDidPress() {
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton("Yes", action: restartGame)
        alert.addButton("No", action: {})
        alert.showWarning("Confirm", subTitle: "Are you sure you want to restart?")
    }
    
    @objc func quitButtonDidPress() {
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton("Yes", action: quitGame)
        alert.addButton("No", action: {})
        alert.showWarning("Confirm", subTitle: "Are you sure you want to quit?")
    }
    
    func restartGame() {
        game = Game(boardSize: 6)
        game.delegate = self
        turn = 1
        board.board = game.board
        board.setNeedsDisplay()
        updateNextMoveView()
    }
    
    func quitGame() {
        performSegue(withIdentifier: "unwindToMainMenu", sender: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        board.setNeedsDisplay()
        nextMoveView.setNeedsDisplay()
        nextMoveView.updateLabelFont()
        
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.updateNextMoveViewConstraints()
        }, completion: nil)
    }
    
    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        if view.bounds.width < view.bounds.height {
            return UITraitCollection(horizontalSizeClass: .compact)
        } else {
            return UITraitCollection(horizontalSizeClass: .regular)
        }
    }
}

