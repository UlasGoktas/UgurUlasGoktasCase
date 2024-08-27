//
//  ProductRequest.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import Foundation

struct ProductRequest: BaseRequest {
    typealias ResponseType = [Product]
    
    var url: URL {
        return URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products")!
    }
}
