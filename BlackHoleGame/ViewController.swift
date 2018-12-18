import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let board = BoardView(frame: CGRect(x: 10, y: 10, width: 300, height: 300))
        board.backgroundColor = .white
        board.board = Game().board
        view.addSubview(board)
    }


}

