//
//  CoinAPIService.swift
//  CoinAPI
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

class CoinAPIService: CoinAPIProtocol {
    
    func getPriceInOtherCurrencies(on dateString: String, _ completion: @escaping (Result<ForexRates, Error>) -> Void) {
        // TODO: Prevent API call as it might run out of limit
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(ForexRates(usd: 1.182306, gbp: 0.855735)))
        }
        return
        
        var components = URLComponents(string: "http://api.exchangeratesapi.io/v1/\(dateString)")!
        
        components.queryItems = [
            URLQueryItem(name: "access_key", value: "3c00fe4ecb3d4008c90006528d53245d"),
            URLQueryItem(name: "symbols", value: "USD,GBP")
        ]
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200 ..< 300 ~= response.statusCode
            else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let resp = try JSONDecoder().decode(ForexConversionResponse.self, from: data)
                completion(.success(resp.rates))
                return
            } catch {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
        }
        
        task.resume()
    }
}
