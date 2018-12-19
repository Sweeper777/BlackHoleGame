import UIKit

protocol BoardViewDelegate : class {
    func didTouchCircle(inRow row: Int, atIndex index: Int)
}
