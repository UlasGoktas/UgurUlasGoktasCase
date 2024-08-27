//
//  BaseRequest.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 26.08.2024.
//

import Foundation

protocol BaseRequest {
    associatedtype ResponseType: Decodable
    
    var url: URL { get }
}
