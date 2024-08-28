//
//  MockNetworkManager.swift
//  UgurUlasGoktasCaseTests
//
//  Created by Ulas Goktas on 28.08.2024.
//

import Foundation
@testable import UgurUlasGoktasCase

class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false
    var jsonFileName: String?
    
    func fetch<T: BaseRequest>(_ request: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "Network Error", code: 500, userInfo: nil)))
        } else {
            if let fileName = jsonFileName, let data = readLocalJSONFile(forName: fileName) {
                do {
                    let response = try JSONDecoder().decode(T.ResponseType.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(NSError(domain: "Decoding Error", code: 502, userInfo: nil)))
                }
            } else {
                completion(.failure(NSError(domain: "File Not Found", code: 404, userInfo: nil)))
            }
        }
    }
    
    private func readLocalJSONFile(forName name: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return data
            } catch {
                print("Error reading local JSON file: \(error)")
            }
        }
        return nil
    }
}

