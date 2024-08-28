//
//  CartDBStrategy.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

protocol CartDBStrategy {
    func add(product: Product) throws
    func update(product: Product) throws
    func delete(product: Product) throws
    func fetchProductList() throws -> [Product]?
    func addToCart(product: Product) throws
    func removeFromCart(product: Product) throws
    func clearCart() throws
}

extension CartDBStrategy {
    func addToCart(product: Product) throws {
        guard let products = try fetchProductList() else { throw CartError.failedToFetchProductList }
        
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            guard var existingProduct = products[safe: index] else { throw CartError.productNotFound }
            existingProduct.quantity = (existingProduct.quantity ?? 0) + 1
            do {
                try update(product: existingProduct)
            } catch {
                throw CartError.failedToUpdateProduct
            }
        } else {
            var newProduct = product
            newProduct.quantity = 1
            do {
                try add(product: newProduct)
            } catch {
                throw CartError.failedToAddProduct
            }
        }
        
        NotificationCenter.default.post(name: .cartDBChanged, object: nil)
    }
    
    func removeFromCart(product: Product) throws {
        guard let products = try fetchProductList() else { throw CartError.failedToFetchProductList }
        
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            guard var existingProduct = products[safe: index] else { throw CartError.productNotFound }
            if existingProduct.quantity ?? 0 > 1 {
                existingProduct.quantity = (existingProduct.quantity ?? 0) - 1
                do {
                    try update(product: existingProduct)
                } catch {
                    throw CartError.failedToUpdateProduct
                }
            } else {
                do {
                    try add(product: existingProduct)
                } catch {
                    throw CartError.failedToAddProduct
                }
            }
        }
        
        NotificationCenter.default.post(name: .cartDBChanged, object: nil)
    }
}
