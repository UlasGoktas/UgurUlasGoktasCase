//
//  Notification+Extension.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

extension Notification.Name {
    static let cartDBChanged = Notification.Name("CartDBChanged")
    static let showLoading = Notification.Name("showLoading")
    static let hideLoading = Notification.Name("hideLoading")
    static let filtersApplied = Notification.Name("filtersApplied")
    static let productListUpdateFavoriteDB = Notification.Name("productListUpdateFavoriteDB")
    static let favoriteListUpdateFavoriteDB = Notification.Name("favoriteListUpdateFavoriteDB")
}
