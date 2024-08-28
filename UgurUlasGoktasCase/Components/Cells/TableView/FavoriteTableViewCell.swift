//
//  FavoriteTableViewCell.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 28.08.2024.
//

import UIKit

final class FavoriteTableViewCell: BaseTableViewCell {
    private let imageViewProduct: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: .regularPoint)
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let labelPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .regularPoint)
        label.textColor = .primaryBlue
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareConstraints() {
        contentView.addSubview(imageViewProduct)
        contentView.addSubview(labelName)
        contentView.addSubview(labelPrice)
        
        NSLayoutConstraint.activate([
            imageViewProduct.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageViewProduct.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageViewProduct.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageViewProduct.widthAnchor.constraint(equalToConstant: 80),
            
            labelName.leadingAnchor.constraint(equalTo: imageViewProduct.trailingAnchor, constant: 8),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            labelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            labelPrice.leadingAnchor.constraint(equalTo: imageViewProduct.trailingAnchor, constant: 8),
            labelPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            labelPrice.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4),
            labelPrice.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with product: Product) {
        labelName.text = product.name
        labelPrice.text = "\(product.price ?? "") \(TextConstants.turkishLiraCurrency.rawValue)"
        if let imageUrl = product.image, let url = URL(string: imageUrl) {
            NetworkManager.shared.loadImage(from: url) { image in
                DispatchQueue.main.async { [weak self] in
                    self?.imageViewProduct.image = image
                }
            }
        }
    }
}
