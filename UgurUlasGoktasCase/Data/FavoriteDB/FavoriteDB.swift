//
//  FavoriteDB.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

class FavoriteDB {
    private var strategy: FavoriteDBStrategy

    init(strategy: FavoriteDBStrategy) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: FavoriteDBStrategy) {
        self.strategy = strategy
    }

    func add(product: Product) throws {
        try strategy.add(product: product)
    }

    func delete(product: Product) throws {
        try strategy.delete(product: product)
    }

    func fetchProductList() throws -> [Product]? {
        return try strategy.fetchProductList()
    }

    func toggle(product: Product) throws {
        try strategy.toggle(product: product)
    }
}
