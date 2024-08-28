//
//  CartViewModel.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

final class CartViewModel: BaseViewModel {
    private var cartDB: CartDB
    private(set) var cartItems: [Product] = []
    var totalPrice: String {
        var total: Double = 0
        cartItems.forEach { product in
            if let price = product.price, let quantity = product.quantity, let price = Double(price) {
                total += price * Double(quantity)
            }
        }
        return "\(total) \(TextConstants.turkishLiraCurrency.rawValue)"
    }

    var cartItemsChanged: (() -> Void)?

    init(cartDB: CartDB = CartDB(strategy: CoreDataCartDB())) {
        self.cartDB = cartDB
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func listenCartItems() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadCartItems), name: .cartDBChanged, object: nil)
    }

    @objc func loadCartItems() {
        guard let cartItems = try? cartDB.fetchProductList() else { return }
        
        self.cartItems = cartItems
        cartItemsChanged?()
    }

    func increaseQuantity(of product: Product) {
        try? cartDB.addToCart(product: product)
    }

    func decreaseQuantity(of product: Product) {
        guard let currentQuantity = product.quantity, currentQuantity > 0 else { return }
        
        if currentQuantity == 1 {
            try? cartDB.delete(product: product)
            loadCartItems()
        } else {
            try? cartDB.removeFromCart(product: product)
        }
    }

    func completePurchase() {
        try? cartDB.clearCart()
    }
}
