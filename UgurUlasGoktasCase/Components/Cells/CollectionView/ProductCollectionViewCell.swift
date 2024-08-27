//
//  ProductCollectionViewCell.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {
    private let imageViewProduct: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .mediumPoint
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let buttonFavorite: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: SystemImages.star.rawValue), for: .normal)
        button.tintColor = .orange
        
        return button
    }()
    
    private let labelProductPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .regularPoint, weight: .regular)
        label.textColor = .blue
        
        return label
    }()
    
    private let labelProductName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .regularPoint, weight: .regular)
        label.textColor = .black
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let buttonAddToCart: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(TextConstants.addToCart.rawValue, for: .normal)
        button.backgroundColor = UIColor(hex: "#2A59FE")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = .mediumPoint
        
        return button
    }()
    
    private var product: Product?
    var addToFavoriteButtonTapped: ((Product?) -> Void)?
    var addToCartButtonTapped: ((Product?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareView()
        prepareButtonActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        prepareView()
        prepareButtonActions()
    }
    
    private func prepareView() {
        contentView.addSubview(imageViewProduct)
        contentView.addSubview(buttonFavorite)
        contentView.addSubview(labelProductPrice)
        contentView.addSubview(labelProductName)
        contentView.addSubview(buttonAddToCart)
        
        NSLayoutConstraint.activate([
            imageViewProduct.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumPoint),
            imageViewProduct.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumPoint),
            imageViewProduct.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumPoint),
            imageViewProduct.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            buttonFavorite.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .regularPoint),
            buttonFavorite.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.regularPoint),
            
            labelProductPrice.topAnchor.constraint(equalTo: imageViewProduct.bottomAnchor, constant: .mediumPoint),
            labelProductPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumPoint),
            labelProductPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumPoint),
            
            labelProductName.topAnchor.constraint(equalTo: labelProductPrice.bottomAnchor, constant: .mediumPoint),
            labelProductName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumPoint),
            labelProductName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumPoint),
            
            buttonAddToCart.topAnchor.constraint(equalTo: labelProductName.bottomAnchor, constant: .extraLargeMediumPoint),
            buttonAddToCart.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumPoint),
            buttonAddToCart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumPoint),
            buttonAddToCart.heightAnchor.constraint(equalToConstant: .doubleRegularPoint),
            buttonAddToCart.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumPoint)
        ])
    }
    
    private func prepareButtonActions() {
        buttonAddToCart.addTarget(self, action: #selector(addToCartButtonOnTap), for: .touchUpInside)
        buttonFavorite.addTarget(self, action: #selector(favoriteButtonOnTap), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageViewProduct.image = nil
        addToFavoriteButtonTapped = nil
        addToCartButtonTapped = nil
        product = nil
    }
    
    func configure(with product: Product, isFavorite: Bool) {
        guard let price = product.price else { return }
        guard let imageURLString = product.image, let imageURL = URL(string: imageURLString) else { return }
        
        self.product = product
        labelProductName.text = product.name
        labelProductPrice.text = "\(price.removeTrailingZeros()) \(TextConstants.turkishLiraCurrency.rawValue)"
        buttonFavorite.setImage(
            UIImage(systemName: isFavorite ? SystemImages.filledStar.rawValue : SystemImages.star.rawValue),
            for: .normal)
        
        NetworkManager.shared.loadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageViewProduct.image = image
            }
        }
    }
    
    @objc private func addToCartButtonOnTap() {
        addToCartButtonTapped?(product)
    }
    
    @objc private func favoriteButtonOnTap() {
        addToFavoriteButtonTapped?(product)
    }
}
