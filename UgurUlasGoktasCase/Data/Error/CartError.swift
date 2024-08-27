//
//  CartError.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

enum CartError: Error {
    case failedToFetchProductList
    case productNotFound
    case failedToUpdateProduct
    case failedToAddProduct
    case failedToRemoveProduct
}
