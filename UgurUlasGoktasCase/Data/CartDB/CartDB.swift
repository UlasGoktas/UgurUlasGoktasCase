//
//  CartDB.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//



final class CartDB {
    private var strategy: CartDBStrategy

    init(strategy: CartDBStrategy) {
        self.strategy = strategy
    }

    func setDBStrategy(_ strategy: CartDBStrategy) {
        self.strategy = strategy
    }

    func add(product: Product) throws {
        try strategy.add(product: product)
    }

    func update(product: Product) throws {
        try strategy.update(product: product)
    }

    func delete(product: Product) throws {
        try strategy.delete(product: product)
    }

    func fetchProductList() throws -> [Product]? {
        return try strategy.fetchProductList()
    }

    func addToCart(product: Product) throws {
        try strategy.addToCart(product: product)
    }

    func removeFromCart(product: Product) throws {
        try strategy.removeFromCart(product: product)
    }
}
