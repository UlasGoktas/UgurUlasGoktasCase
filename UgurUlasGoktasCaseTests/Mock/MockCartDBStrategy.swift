//
//  MockCartDBStrategy.swift
//  UgurUlasGoktasCaseTests
//
//  Created by Ulas Goktas on 29.08.2024.
//

import Foundation
@testable import UgurUlasGoktasCase

class MockCartDBStrategy: CartDBStrategy {
    var products: [Product] = []
    
    func add(product: Product) throws {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            var existingProduct = products[index]
            existingProduct.quantity = (existingProduct.quantity ?? 0) + 1
            products[index] = existingProduct
        } else {
            var newProduct = product
            newProduct.quantity = 1
            products.append(newProduct)
        }
    }
    
    func update(product: Product) throws {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
        }
    }
    
    func delete(product: Product) throws {
        products.removeAll { $0.id == product.id }
    }
    
    func fetchProductList() throws -> [Product]? {
        return products
    }
    
    func clearCart() throws {
        products.removeAll()
    }
}
