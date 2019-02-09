import UIKit
import SnapKit
import SwiftyButton
import SCLAlertView

class TwoPlayerGameViewController: GameViewControllerBase {
    
    override func didTouchCircle(inRow row: Int, atIndex index: Int) {
        if game.ended{
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
                ).perform()
            updateNextMoveView()
        }
    }
}

