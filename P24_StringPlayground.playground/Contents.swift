import UIKit

// challenge 1
extension String {
    func withPrefix(_ prefix: String) -> String {
        guard case self.hasPrefix(prefix) = self.hasPrefix(prefix) else { return self }
        return prefix + self
    }
}

// challenge 2
extension String {
    var isNumeric: Bool {
        return Double(self) != nil ? true : false
    }
}

// challenge 3
extension String {
    var lines: [Substring] {
        return self.split(separator: "\n")
    }
}
