//
//  FilterSelectionTableViewCell.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class FilterSelectionTableViewCell: BaseTableViewCell {
    private let labelSelection: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .regularPoint, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    private let imageViewSelection: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primaryBlue
        
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareView() {
        contentView.addSubview(labelSelection)
        contentView.addSubview(imageViewSelection)
        
        NSLayoutConstraint.activate([
            imageViewSelection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .regularPoint),
            imageViewSelection.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: .regularPoint),
            imageViewSelection.widthAnchor.constraint(equalToConstant: .largePoint),
            imageViewSelection.heightAnchor.constraint(equalToConstant: .largePoint),
            
            labelSelection.leadingAnchor.constraint(equalTo: imageViewSelection.trailingAnchor, constant: .regularPoint),
            labelSelection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.regularPoint),
            labelSelection.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: .regularPoint)
        ])
    }

    func configure(with selection: String, isSelected: Bool) {
        labelSelection.text = selection
        imageViewSelection.image = UIImage(systemName: isSelected ? SystemImages.filledCheckBox.rawValue : SystemImages.checkBox.rawValue)
    }
}
