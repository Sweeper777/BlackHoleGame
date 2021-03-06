enum Tile : Equatable{
    case empty
    case red(number: Int)
    case blue(number: Int)
    case wall
}

extension TriangularArray where T == Tile {
    var emptyCount: Int {
        return self.filter {
            if case .empty = $0 {
                return true
            }
            return false
        }.count
    }
    
    func indexOfEmpty() -> (Int, Int)? {
        for i in 0..<rowCount {
            for j in 0..<(i + 1) {
                if case .some(.empty) = self[i, j] {
                    return (i, j)
                }
            }
        }
        return nil
    }
}

enum PlayerSide {
    case red
    case blue
}

enum GameResult {
    case redWins(red: Int, blue: Int)
    case blueWins(red: Int, blue: Int)
    case draw(both: Int)
    case undecided
}
