//
//  CartViewController.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class CartViewController: BaseViewController {
    let viewModel = CartViewModel()
    private let emptyCartValue = "0 ₺"
    private let tableView = UITableView()
    private let labelTotalPrice = UILabel()
    private let buttonComplete = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViews()
        bindViewModel()
        viewModel.loadCartItems()
        updateBadge()
    }
    
    private func updateBadge() {
        let itemCount = viewModel.cartItems.reduce(0) { $0 + ($1.quantity ?? 0) }
        tabBarItem.badgeValue = itemCount > 0 ? "\(itemCount)" : nil
    }
    
    private func prepareViews() {
        view.backgroundColor = .white
        
        prepareTableView()
        prepareTotalPriceLabel()
        prepareCompleteButton()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .regularPoint),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            tableView.bottomAnchor.constraint(equalTo: labelTotalPrice.topAnchor, constant: -.mediumPoint),
            
            labelTotalPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            labelTotalPrice.bottomAnchor.constraint(equalTo: buttonComplete.topAnchor, constant: -.mediumPoint),
            
            buttonComplete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .regularPoint),
            buttonComplete.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.regularPoint),
            buttonComplete.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.mediumPoint),
            buttonComplete.heightAnchor.constraint(equalToConstant: .doubleLargePoint)
        ])
    }
    
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    private func prepareTotalPriceLabel() {
        view.addSubview(labelTotalPrice)
        labelTotalPrice.translatesAutoresizingMaskIntoConstraints = false
        labelTotalPrice.font = UIFont.boldSystemFont(ofSize: .largePoint)
        labelTotalPrice.textColor = .black
    }
    
    private func prepareCompleteButton() {
        view.addSubview(buttonComplete)
        buttonComplete.translatesAutoresizingMaskIntoConstraints = false
        buttonComplete.backgroundColor = .blue
        buttonComplete.setTitle(TextConstants.complete.rawValue, for: .normal)
        buttonComplete.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.listenCartItems()
        viewModel.cartItemsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.labelTotalPrice.text = "\(TextConstants.total.rawValue) \(self?.viewModel.totalPrice ?? self?.emptyCartValue ?? .empty)"
                
                // TODO: badge
                let itemCount = self?.viewModel.cartItems.reduce(0) { $0 + ($1.quantity ?? 0) }
                self?.tabBarItem.badgeValue = itemCount ?? 0 > 0 ? "\(itemCount)" : nil
            }
        }
    }
    
    @objc private func completeButtonTapped() {
        viewModel.completePurchase()
    }
}

// MARK: TableView extension
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        guard let cartItem = viewModel.cartItems[safe: indexPath.row] else { return cell }
        guard let quantity = cartItem.quantity else { return cell }
        cell.configure(with: cartItem, quantity: quantity, increaseItem: { [weak self] in
            self?.viewModel.increaseQuantity(of: cartItem)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }, decreaseItem: { [weak self] in
            self?.viewModel.decreaseQuantity(of: cartItem)
            tableView.reloadData()
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let product = viewModel.cartItems[safe: indexPath.row] else { return }
        let productDetailViewController = ProductDetailViewController(product: product)
        
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}
