//
//  Array+Extension.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
