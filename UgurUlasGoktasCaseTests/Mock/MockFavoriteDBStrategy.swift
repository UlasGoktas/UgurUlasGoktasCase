//
//  MockFavoriteDBStrategy.swift
//  UgurUlasGoktasCaseTests
//
//  Created by Ulas Goktas on 29.08.2024.
//

import Foundation
@testable import UgurUlasGoktasCase

class MockFavoriteDBStrategy: FavoriteDBStrategy {
    var products: [Product] = []
    
    func add(product: Product) throws {
        products.append(product)
    }
    
    func delete(product: Product) throws {
        products.removeAll { $0.id == product.id }
    }
    
    func fetchProductList() throws -> [Product]? {
        return products
    }
    
    func toggle(product: Product) throws {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products.remove(at: index)
        } else {
            products.append(product)
        }
    }
}
