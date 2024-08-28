//
//  CartTableViewCell.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class CartTableViewCell: BaseTableViewCell {
    private let labelName = UILabel()
    private let labelPrice = UILabel()
    private let labelQuantity = UILabel()
    private let buttonIncrease = UIButton()
    private let buttonDecrease = UIButton()

    private var increaseItem: (() -> Void)?
    private var decreaseItem: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with product: Product, quantity: Int, increaseItem: @escaping () -> Void, decreaseItem: @escaping () -> Void) {
        labelName.text = product.name
        labelPrice.text = product.price
        labelQuantity.text = "\(quantity)"
        self.increaseItem = increaseItem
        self.decreaseItem = decreaseItem
    }

    private func prepareView() {
        labelName.font = UIFont.systemFont(ofSize: .regularPoint)
        labelPrice.font = UIFont.systemFont(ofSize: .regularPoint)
        labelPrice.textColor = .primaryBlue
        
        labelQuantity.font = UIFont.systemFont(ofSize: .regularPoint)
        labelQuantity.backgroundColor = .primaryBlue
        labelQuantity.textColor = .white
        labelQuantity.textAlignment = .center
        labelQuantity.layer.masksToBounds = true

        buttonIncrease.setTitle(TextConstants.plus.rawValue, for: .normal)
        buttonIncrease.backgroundColor = .primaryLightGray
        buttonIncrease.setTitleColor(.black, for: .normal)
        buttonIncrease.layer.cornerRadius = 4
        buttonIncrease.layer.masksToBounds = true
        buttonIncrease.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)

        buttonDecrease.setTitle(TextConstants.minus.rawValue, for: .normal)
        buttonDecrease.backgroundColor = .primaryLightGray
        buttonDecrease.setTitleColor(.black, for: .normal)
        buttonDecrease.layer.cornerRadius = .smallPoint
        buttonDecrease.layer.masksToBounds = true
        buttonDecrease.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)

        labelQuantity.widthAnchor.constraint(equalToConstant: .doubleRegularPoint).isActive = true
        labelQuantity.heightAnchor.constraint(equalToConstant: .doubleRegularPoint).isActive = true
        buttonIncrease.widthAnchor.constraint(equalToConstant: .doubleRegularPoint).isActive = true
        buttonIncrease.heightAnchor.constraint(equalToConstant: .doubleRegularPoint).isActive = true
        buttonDecrease.widthAnchor.constraint(equalToConstant: .doubleRegularPoint).isActive = true
        buttonDecrease.heightAnchor.constraint(equalToConstant: .doubleRegularPoint).isActive = true

        let stackView = UIStackView(arrangedSubviews: [buttonDecrease, labelQuantity, buttonIncrease])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally

        let labelsStackView = UIStackView(arrangedSubviews: [labelName, labelPrice])
        labelsStackView.axis = .vertical

        let mainStackView = UIStackView(arrangedSubviews: [labelsStackView, stackView])
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.spacing = .regularPoint

        contentView.addSubview(mainStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    @objc private func increaseButtonTapped() {
        increaseItem?()
    }

    @objc private func decreaseButtonTapped() {
        decreaseItem?()
    }
}
