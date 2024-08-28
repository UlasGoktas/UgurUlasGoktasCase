//
//  FavoriteListViewModel.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

final class FavoriteListViewModel: BaseViewModel {
    private let favoriteDB: FavoriteDB
    private(set) var favoriteItems: [Product] = []
    var itemsChanged: (() -> Void)?

    init(favoriteDB: FavoriteDB = FavoriteDB(strategy: CoreDataFavoriteDB())) {
        self.favoriteDB = favoriteDB
    }
    
    func loadFavoriteItems() {
        do {
            if let items = try favoriteDB.fetchProductList() {
                self.favoriteItems = items
                itemsChanged?()
            }
        } catch {
            print("Failed to load favorite items: \(error)")
        }
    }
    
    func removeItem(at index: Int) {
        guard index < favoriteItems.count else { return }
        let product = favoriteItems[index]
        do {
            try favoriteDB.delete(product: product)
            loadFavoriteItems()
        } catch {
            print("Failed to remove item: \(error)")
        }
        
        NotificationCenter.default.post(name: .favoriteListUpdateFavoriteDB, object: nil)
    }
}
