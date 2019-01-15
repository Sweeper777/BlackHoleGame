import UIKit

fileprivate func shouldContinueToEnlarge(targetSize: CGSize, currentSize: CGSize) -> Bool {
    return targetSize.height > currentSize.height && targetSize.width > currentSize.width
}

func fontSizeThatFits(size: CGSize, text: NSString, font: UIFont) -> CGFloat {
    var fontToTest = font.withSize(0)
    var currentSize = text.size(withAttributes: [NSAttributedString.Key.font: fontToTest])
    var fontSize = CGFloat(1)
    while shouldContinueToEnlarge(targetSize: size, currentSize: currentSize) {
        fontToTest = fontToTest.withSize(fontSize)
        currentSize = text.size(withAttributes: [NSAttributedString.Key.font: fontToTest])
        fontSize += 1
    }
    return fontSize - 1
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UILabel {
    func updateFontSizeToFit(size: CGSize) {
        let fontSize = fontSizeThatFits(size: size, text: (text ?? "a") as NSString, font: font) * 0.9
        font = font.withSize(fontSize)
    }
    
}
