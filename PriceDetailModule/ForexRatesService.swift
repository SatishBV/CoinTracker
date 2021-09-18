//
//  ExchangeRatesClient.swift
//  PriceDetailModule
//
//  Created by Satish Bandaru on 18/09/21.
//

import Foundation
import Utilities

protocol ForexRatesProtocol {
    func forexRates(for dateString: String, _ completion: @escaping (Result<ForexConversionResponse, NetworkError>) -> Void)
}

class ForexRatesService: NetworkClient, ForexRatesProtocol {
    func forexRates(for dateString: String, _ completion: @escaping (Result<ForexConversionResponse, NetworkError>) -> Void) {
        guard var components = URLComponents(string: "http://api.exchangeratesapi.io/v1/\(dateString)") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "access_key", value: "3c00fe4ecb3d4008c90006528d53245d"),
            URLQueryItem(name: "symbols", value: "USD,GBP")
        ]
        
        self.fetch(from: components, for: ForexConversionResponse.self) { result in
            completion(result)
        }
    }
}
