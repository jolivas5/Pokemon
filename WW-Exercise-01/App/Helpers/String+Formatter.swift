//
//  String+Formatter.swift


import Foundation

extension String {
    func stringByRemovingSpecifiedChars(_ charsToRemove: String) -> String {

        var newSelf = self

        charsToRemove.forEach {
            let tempString = newSelf.replacingOccurrences(of: String($0), with: "")
            newSelf = tempString
        }

        return newSelf
    }
}
