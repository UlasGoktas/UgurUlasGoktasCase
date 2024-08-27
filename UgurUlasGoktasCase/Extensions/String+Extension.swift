//
//  String+Extension.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

extension String {
    static let empty = ""
    
    func convertToDate(withFormat format: DateFormat = .dotDateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let output = dateFormatter.date(from: self)
        return output
    }
}

extension String {
    func removeTrailingZeros() -> String {
        let characters = self.components(separatedBy: " ")
        var editedString: [String] = []

        for character in characters {
            if let value = Double(character) {
                if value.truncatingRemainder(dividingBy: 1) == 0 {
                    editedString.append(String(format: "%.0f", value))
                } else {
                    editedString.append(character)
                }
            } else {
                editedString.append(character)
            }
        }
        return editedString.joined(separator: " ")
    }
}
