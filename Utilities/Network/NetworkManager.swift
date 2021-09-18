//
//  NetworkManager.swift
//  Utilities
//
//  Created by Satish Bandaru on 18/09/21.
//

import Foundation

public class NetworkManager<T: Decodable> {
    public static func fetch(from components: URLComponents, completion: @escaping (Result<T, NetworkError>) -> Void) {
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
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
                return
            } catch {
                completion(.failure(.parsingError))
                return
            }
        }.resume()
    }
}
