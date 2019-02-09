import UIKit
import SnapKit
import SwiftyButton
import SCLAlertView

class AIGameViewController: GameViewControllerBase {

    var aiQueue = DispatchQueue(label: "aiQueue")
    
    var turn = 1
    var myColor: PlayerSide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myColor = [PlayerSide.red, .blue].randomElement()!
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: showPlayerSide)
    }
    
    func showPlayerSide() {
        if myColor == .red {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 56, height: 56), false, 0)
            UIColor.red.setFill()
            let path = UIBezierPath(ovalIn: CGRect.zero.with(width: 56).with(height: 56))
            path.fill()
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(kCircleIconHeight: 56, showCloseButton: false))
            alert.addButton("OK".localized, action: {})
            _ = alert.showCustom("Your color is red. You go first.", subTitle: "", color: .black, icon: image)
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 56, height: 56), false, 0)
            UIColor.blue.setFill()
            let path = UIBezierPath(ovalIn: CGRect.zero.with(width: 56).with(height: 56))
            path.fill()
            let image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(kCircleIconHeight: 56, showCloseButton: false))
            alert.addButton("OK".localized, action: aiTurn)
            _ = alert.showCustom("Your color is blue. The AI goes first.", subTitle: "", color: .black, icon: image)
        }
    }
    
    func searchDepth(forTurn turn: Int) -> Int {
        if game.totalMoves - turn - 1 > 10 {
            return 3
        }
        if game.totalMoves - turn - 1 > 6 {
            return 4
        }
        return 6
    }
    
    override func didTouchCircle(inRow row: Int, atIndex index: Int) {
        if game.currentTurn != myColor || game.ended{
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
    
    func aiTurn() {
        guard !game.ended else { return }
        
        self.board.board = self.game.board
        self.turn += 1
        aiQueue.async {
            [weak self] in
            guard let `self` = self else { return }
            let move: (row: Int, index: Int)
            let ai: GameAI
            if self.turn >= 8 {
                ai = HeuristicAI(game: Game(copyOf: self.game), myColor: self.game.currentTurn)
                move = (ai as! HeuristicAI).getNextMove(searchDepth: self.searchDepth(forTurn: self.turn))
            } else {
                ai = RandomAI(game: Game(copyOf: self.game), myColor: self.game.currentTurn)
                move = ai.getNextMove()
            }
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
    
    override func restartGame() {
        game = Game(boardSize: 6)
        game.delegate = self
        turn = 1
        myColor = [PlayerSide.red, .blue].randomElement()
        board.board = game.board
        board.setNeedsDisplay()
        updateNextMoveView()
        showPlayerSide()
    }
}

