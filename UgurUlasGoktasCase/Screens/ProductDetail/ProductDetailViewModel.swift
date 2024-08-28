//
//  ProductDetailViewModel.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

final class ProductDetailViewModel: BaseViewModel {
    private var cartDB: CartDB
    
    init(cartDB: CartDB = CartDB(strategy: CoreDataCartDB())) {
        self.cartDB = cartDB
    }
    
    func addToCart(product: Product) {
        try? cartDB.addToCart(product: product)
    }
}
