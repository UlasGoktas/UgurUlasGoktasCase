//
//  FavoriteError.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

enum FavoriteDBError: Error {
    case productNotFound
    case failedToAddProduct
    case failedToDeleteProduct
    case failedToFetchProducts
}
