import Foundation

protocol GameDelegate: class {
    func gameDidEnd(game: Game, result: GameResult)
}
