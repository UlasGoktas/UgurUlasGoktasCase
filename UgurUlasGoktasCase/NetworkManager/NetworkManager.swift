//
//  NetworkManager.swift
//  UgurUlasGoktasCase
//
//  Created by Ulas Goktas on 27.08.2024.
//

import UIKit

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: BaseRequest>(_ request: T, completion: @escaping (Result<T.ResponseType, Error>) -> Void) {
        NotificationCenter.default.post(name: .didStartLoading, object: nil)

        let task = URLSession.shared.dataTask(with: request.url) { data, response, error in
            defer {
                NotificationCenter.default.post(name: .didFinishLoading, object: nil)
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(T.ResponseType.self, from: data)
                completion(.success(response))
            } catch let decodingError as DecodingError {
                completion(.failure(decodingError))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Image loading error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}
