//
//  FavoriteDBStrategy.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

protocol FavoriteDBStrategy {
    func add(product: Product) throws
    func delete(product: Product) throws
    func fetchProductList() throws -> [Product]?
    func toggle(product: Product) throws
}

extension FavoriteDBStrategy {
    func toggle(product: Product) throws {
        guard let products = try fetchProductList() else { throw FavoriteDBError.failedToFetchProducts }
        
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            guard let productToDelete = products[safe: index] else { throw FavoriteDBError.productNotFound }
            do {
                try delete(product: productToDelete)
            } catch {
                throw FavoriteDBError.failedToDeleteProduct
            }
        } else {
            do {
                try add(product: product)
            } catch {
                throw FavoriteDBError.failedToAddProduct
            }
        }
    }
}
