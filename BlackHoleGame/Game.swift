import Foundation

class Game {
    var board: TriangularArray<Tile>
    var currentTurn = PlayerSide.red
    var currentNumber = 1
    let boardSize: Int
    let totalMoves: Int
    
    var ended: Bool = false
    
    weak var delegate: GameDelegate?
    
    init(boardSize: Int = 6) {
        self.boardSize = boardSize
        board = TriangularArray(rowCount: boardSize, defaultValue: .empty)
        switch boardSize {
        case 4:
            totalMoves = 8
            board[2, 1] = .wall
        case 7:
            totalMoves = 20
            [(4, 2), (2, 0), (4, 0), (2, 2), (4, 4), (6, 2), (6, 4)]
                .forEach { board[$0.0, $0.1] = .wall }
        case 6:
            totalMoves = 20
        case 5:
            totalMoves = 14
        default:
            fatalError("Invalid Board Size: \(boardSize)")
        }
    }
    
    init(copyOf game: Game) {
        board = game.board
        currentTurn = game.currentTurn
        currentNumber = game.currentNumber
        boardSize = game.boardSize
        totalMoves = game.totalMoves
    }
    
    func canMakeMove(row: Int, index: Int) -> Bool {
        switch board[row, index] {
        case .some(.empty):
            return true
        default:
            return false
        }
    }
    
    @discardableResult
    func makeMove(row: Int, index: Int) -> Bool {
        if board.emptyCount > 1 {
            if case .some(.empty) = board[row, index] {
                switch currentTurn {
                case .red:
                    board[row, index] = .red(number: currentNumber)
                    currentTurn = .blue
                case .blue:
                    board[row, index] = .blue(number: currentNumber)
                    currentTurn = .red
                    currentNumber += 1
                }
                let result = checkWin()
                switch result {
                case .blueWins, .redWins, .draw:
                    delegate?.gameDidEnd(game: self, result: result)
                case .undecided:
                    break
                }
                return true
            }
        }
        return false
    }
    
    func checkWin() -> GameResult {
        if board.emptyCount != 1 {
            return .undecided
        }
        guard let indexOfEmpty = board.indexOfEmpty() else { return .undecided }
        let adjacentTiles = board.adjacentElements(forRow: indexOfEmpty.0, index: indexOfEmpty.1)
        let (redScore, blueScore) = adjacentTiles.reduce((0, 0), {
            result, tile in
            if case .red(let num)  = tile {
                return (result.0 + num, result.1)
            } else if case .blue(let num) = tile {
                return (result.0, result.1 + num)
            }
            return result
        })
        ended = true
        if redScore < blueScore {
            return .redWins(red: redScore, blue: blueScore)
        } else if redScore > blueScore {
            return .blueWins(red: redScore, blue: blueScore)
        } else {
            return .draw(both: redScore)
        }
    }
    
    
}

extension Game: CustomStringConvertible {
    var description: String {
        var desc = ""
        for i in 0..<boardSize {
            for _ in 0..<(boardSize - i - 1) {
                desc += " "
            }
            for j in 0..<(i + 1) {
                switch board[i, j]! {
                case .empty:
                    desc += ANSIColors.white + "0 "
                case .red(10):
                    desc += ANSIColors.red + "⒑ "
                case .blue(10):
                    desc += ANSIColors.blue + "⒑ "
                case .red(let num):
                    desc += ANSIColors.red + "\(num) "
                case .blue(let num):
                    desc += ANSIColors.blue + "\(num) "
                case .wall:
                    desc += ANSIColors.black + "x "
                }
            }
            desc += "\n"
        }
        return desc
    }
}
