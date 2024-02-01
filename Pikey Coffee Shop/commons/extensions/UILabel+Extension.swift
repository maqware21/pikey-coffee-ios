

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods

public extension UILabel {
    /// SwifterSwift: Initialize a UILabel with text.
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// SwifterSwift: Initialize a UILabel with a text and font style.
    ///
    /// - Parameters:
    ///   - text: the label's text.
    ///   - style: the text style of the label, used to determine which font should be used.
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        font = UIFont.preferredFont(forTextStyle: style)
        self.text = text
    }

    /// SwifterSwift: Required height for a label.
    var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
    typealias MethodHandler = (_ string: String?) -> Void
    
    func addRangeGesture(stringRange: String, function: @escaping MethodHandler) {
        let recognizer = RangeGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        recognizer.stringRange = stringRange
        recognizer.function = function
        self.isUserInteractionEnabled = true
        let tapgesture: UITapGestureRecognizer = recognizer
        tapgesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapgesture)
    }
    
    func addRangeGestures(stringRanges: [String], function: @escaping MethodHandler) {
        let recognizer = RangeGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        recognizer.stringRanges = stringRanges
        recognizer.function = function
        self.isUserInteractionEnabled = true
        let tapgesture: UITapGestureRecognizer = recognizer
        tapgesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapgesture)
    }
    
    @objc func tappedOnLabel(_ gesture: RangeGestureRecognizer) {
        guard let text = self.text else { return }
        if gesture.stringRanges?.count ?? 0 > 0 {
            gesture.stringRanges?.forEach({ string in
                let stringRange = (text as NSString).range(of: string)
                if gesture.didTapAttributedTextInLabel(label: self, inRange: stringRange) {
                    guard let existedFunction = gesture.function else { return }
                    existedFunction(string)
                }
            })
        } else {
            let stringRange = (text as NSString).range(of: gesture.stringRange ?? "")
            if gesture.didTapAttributedTextInLabel(label: self, inRange: stringRange) {
                guard let existedFunction = gesture.function else { return }
                existedFunction(gesture.stringRange)
            }
        }
    }
    
    
    func tappableLabels(string: String,
                        tappableStrings: [String],
                        textColor: UIColor,
                        font: UIFont? = nil,
                        isUnderLined: Bool) {
        
        let attrText = NSMutableAttributedString(string: string)
        for tappableString in tappableStrings {
            let range = (string as NSString).range(of: tappableString)
            var attr = [
                            NSAttributedString.Key.underlineStyle: isUnderLined ? NSUnderlineStyle.single.rawValue : "",
                            NSAttributedString.Key.foregroundColor: textColor
            ] as [NSAttributedString.Key : Any]
            if let font = font {
                attr[NSAttributedString.Key.font] = font
            }
            attrText.addAttributes(attr, range: range)
        }
        
        self.attributedText = attrText
    }
}

#endif
