//
//  MockCartDB.swift
//  UgurUlasGoktasCaseTests
//
//  Created by Ulas Goktas on 28.08.2024.
//

import Foundation
@testable import UgurUlasGoktasCase

class MockCartDB: CartDB {
    var products: [Product] = []
    
    override func addToCart(product: Product) throws {
        products.append(product)
    }
}
