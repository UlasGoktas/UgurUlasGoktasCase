//
//  ProductDetailViewController.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class ProductDetailViewController: BaseViewController {
    let viewModel = ProductDetailViewModel()
    var product: Product
    private let productImageViewHeight: CGFloat = 225
    private let buttonHeight: CGFloat = 180

    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageViewProduct: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let labelProductName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: .regularPoint)
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let textViewProductDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: .regularPoint)
        textView.isEditable = false
        
        return textView
    }()
    
    private let stackViewPrice: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let labelPriceText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .regularPoint)
        label.text = TextConstants.price.rawValue
        label.textColor = .primaryBlue
        
        return label
    }()
    
    private let labelProductPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: .regularPoint)
        
        return label
    }()
    
    private let buttonAddToCart: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(TextConstants.addToCart.rawValue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: .regularPoint)
        button.backgroundColor = .primaryBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = .smallPoint
        button.addTarget(self, action: #selector(addToCartButtonOnTap), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = product.name
        prepareViews()
        configure()
    }
    
    private func prepareViews() {
        view.addSubview(imageViewProduct)
        view.addSubview(labelProductName)
        view.addSubview(textViewProductDescription)
        view.addSubview(stackViewPrice)
        view.addSubview(buttonAddToCart)
        
        stackViewPrice.addArrangedSubview(labelPriceText)
        stackViewPrice.addArrangedSubview(labelProductPrice)
        
        NSLayoutConstraint.activate([
            imageViewProduct.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .regularPoint),
            imageViewProduct.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            imageViewProduct.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            imageViewProduct.heightAnchor.constraint(equalToConstant: productImageViewHeight),
            
            labelProductName.topAnchor.constraint(equalTo: imageViewProduct.bottomAnchor, constant: .regularPoint),
            labelProductName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            labelProductName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            
            textViewProductDescription.topAnchor.constraint(equalTo: labelProductName.bottomAnchor, constant: .regularPoint),
            textViewProductDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            textViewProductDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),

            stackViewPrice.topAnchor.constraint(equalTo: textViewProductDescription.bottomAnchor, constant: .regularPoint),
            stackViewPrice.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.regularPoint),
            stackViewPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            
            buttonAddToCart.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.regularPoint),
            buttonAddToCart.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            buttonAddToCart.heightAnchor.constraint(equalToConstant: .doubleRegularPoint),
            buttonAddToCart.widthAnchor.constraint(equalToConstant: buttonHeight),
            buttonAddToCart.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.regularPoint)
        ])
    }
    
    @objc private func addToCartButtonOnTap() {
        viewModel.addToCart(product: product)
    }
    
    private func configure() {
        labelProductName.text = product.name
        textViewProductDescription.text = product.description
        if let price = product.price {
            labelProductPrice.text = "\(price) \(TextConstants.turkishLiraCurrency.rawValue)"
        }
        
        if let imageUrl = product.image, let url = URL(string: imageUrl) {
            NetworkManager.shared.loadImage(from: url) { image in
                DispatchQueue.main.async { [weak self] in
                    self?.imageViewProduct.image = image
                }
            }
        }
    }
}
