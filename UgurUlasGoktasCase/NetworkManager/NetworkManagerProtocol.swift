//
//  NetworkManagerProtocol.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

protocol NetworkManagerProtocol {
    func fetch<T: BaseRequest>(_ request: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void)
}
