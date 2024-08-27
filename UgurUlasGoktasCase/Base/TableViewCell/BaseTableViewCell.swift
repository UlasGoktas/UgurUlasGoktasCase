//
//  BaseTableViewCell.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 26.08.2024.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareCell()
    }
    
    private func prepareCell() {
        let clearView = UIView()
        clearView.backgroundColor = .clear
        selectedBackgroundView = clearView
    }
}
