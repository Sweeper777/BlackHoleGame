protocol GameAI {
    var myColor: PlayerSide { get }
    var game: Game { get }
    
    func getNextMove() -> (row: Int, index: Int)
}

extension GameAI {
    func getAvailableMoves() -> [(row: Int, index: Int)] {
        var moves = [(row: Int, index: Int)]()
        for i in 0..<game.boardSize {
            for j in 0..<(i + 1) {
                if game.canMakeMove(row: i, index: j) {
                    moves.append((i, j))
                }
            }
        }
        return moves
    }
}

class HeuristicAI : GameAI {
    
    var game: Game
    
    let myColor: PlayerSide
    
    init(game: Game, myColor: PlayerSide) {
        self.game = game
        self.myColor = myColor
    }
    
    func iWon(gameResult: GameResult) -> Bool {
        switch (myColor, gameResult) {
        case (.red, .redWins), (.blue, .blueWins):
            return true
        default:
            return false
        }
    }
    
    func evaluateHeuristics() -> Int {
        let result = game.checkWin()
        switch result {
        case .draw:
            return 100
        case .undecided:
            return evaluateInUndecidedCase()
        default:
            return 10000 * (iWon(gameResult: result) ? 1 : -1)
        }
    }
    
    func evaluateInUndecidedCase() -> Int {
        var results = [GameResult]()
        for i in 0..<game.board.rowCount {
            for j in 0..<i+1 {
                if case .some(.empty) = game.board[i, j] {
                    results.append(evaluateAdjacnetTiles(at: (i, j)))
                }
            }
        }
        results = results.filter { if case .draw = $0 { return false } else { return true } }
        let iWinCount = results.filter(iWon).count
        let iLoseCount = results.count - iWinCount
        return iWinCount - iLoseCount
    }
    
    func evaluateAdjacnetTiles(at indexOfEmpty: (row: Int, index: Int)) -> GameResult {
        let adjacentTiles = game.board.adjacentElements(forRow: indexOfEmpty.row, index: indexOfEmpty.index)
        let (redScore, blueScore) = adjacentTiles.reduce((0, 0), {
            result, tile in
            if case .red(let num)  = tile {
                return (result.0 + num, result.1)
            } else if case .blue(let num) = tile {
                return (result.0, result.1 + num)
            }
            return result
        })
        if redScore < blueScore {
            return .redWins(red: redScore, blue: blueScore)
        } else if redScore > blueScore {
            return .blueWins(red: redScore, blue: blueScore)
        } else {
            return .draw(both: redScore)
        }
    }
    
    func getAvailableMoves() -> [(row: Int, index: Int)] {
        var moves = [(row: Int, index: Int)]()
        for i in 0..<game.boardSize {
            for j in 0..<(i + 1) {
                if game.canMakeMove(row: i, index: j) {
                    moves.append((i, j))
                }
            }
        }
        return moves
    }
    
    private func minimax(depth: Int, color: PlayerSide) -> (score: Int, row: Int, index: Int) {
        func isUndecied(_ result: GameResult) -> Bool {
            if case .undecided = result {
                return true
            }
            return false
        }
        
        var bestScore = color == myColor ? Int.min : Int.max
        var currentScore: Int
        var bestMove: (row: Int, index: Int)?
        if !isUndecied(game.checkWin()) || depth == 0 {
            bestScore = evaluateHeuristics()
        } else {
            for move in getAvailableMoves() {
                game.makeMove(row: move.row, index: move.index)
                if color == myColor {
                    currentScore = minimax(depth: depth - 1, color: game.currentTurn).score
                    if currentScore > bestScore {
                        bestScore = currentScore
                        bestMove = move
                    }
                } else {
                    currentScore = minimax(depth: depth - 1, color: game.currentTurn).score
                    if currentScore < bestScore {
                        bestScore = currentScore
                        bestMove = move
                    }
                }
               
                undoMove(row: move.row, index: move.index)
            }
        }
        return (bestScore, bestMove?.row ?? 0, bestMove?.index ?? 0)
    }
    
    func getNextMove(searchDepth: Int = 4) -> (row: Int, index: Int) {
        let result = minimax(depth: searchDepth, color: myColor)
        return (result.row, result.index)
    }
    
    func undoMove(row: Int, index: Int) {
        game.board[row, index] = .empty
        if game.currentTurn == .red {
            game.currentTurn = .blue
            game.currentNumber -= 1
        } else {
            game.currentTurn = .red
        }
    }
}
