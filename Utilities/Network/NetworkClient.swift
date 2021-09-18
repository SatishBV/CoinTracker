//
//  NetworkClient.swift
//  Utilities
//
//  Created by Satish Bandaru on 18/09/21.
//

import Foundation

public protocol NetworkClient {
    func fetch(from components: URLComponents, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

public extension NetworkClient {
    func fetch(from components: URLComponents, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = components.url else {
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.error(error)))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard 200..<300 ~= response.statusCode else {
                completion(.failure(.statusCodeError(code: response.statusCode)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
