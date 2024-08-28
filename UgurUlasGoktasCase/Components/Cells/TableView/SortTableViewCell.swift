//
//  SortTableViewCell.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class SortTableViewCell: BaseTableViewCell {
    private let labelSortSelection: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .regularPoint, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    private let imageViewSortSelection: UIImageView = {
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
        super.init(coder: coder)
        
        prepareView()
    }
    
    private func prepareView() {
        contentView.addSubview(labelSortSelection)
        contentView.addSubview(imageViewSortSelection)
        
        NSLayoutConstraint.activate([
            imageViewSortSelection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .regularPoint),
            imageViewSortSelection.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: .regularPoint),
            imageViewSortSelection.widthAnchor.constraint(equalToConstant: .largePoint),
            imageViewSortSelection.heightAnchor.constraint(equalToConstant: .largePoint),
            
            labelSortSelection.leadingAnchor.constraint(equalTo: imageViewSortSelection.trailingAnchor, constant: .regularPoint),
            labelSortSelection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.regularPoint),
            labelSortSelection.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: .regularPoint)
        ])
    }
    
    func configure(with selection: String, isSelected: Bool) {
        labelSortSelection.text = selection
        imageViewSortSelection.image = UIImage(systemName: isSelected ? SystemImages.filledCircle.rawValue : SystemImages.circle.rawValue)
    }
}
