//
//  CoinGeckoClient.swift
//  CoinHistory
//
//  Created by Satish Bandaru on 18/09/21.
//

import Foundation
import Utilities

protocol CoinGeckoProtocol {
    func fetchHistoricalPrices(_ completion: @escaping (Result<HistoricalPricesResponse, NetworkError>) -> Void)
    func fetchCurrentBitCoinPrice(_ completion: @escaping (Result<CurrentPriceResponse, NetworkError>) -> Void)
}

class CoinGeckoService: NetworkClient, CoinGeckoProtocol {
    func fetchHistoricalPrices(_ completion: @escaping (Result<HistoricalPricesResponse, NetworkError>) -> Void) {
        guard var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "eur"),
            URLQueryItem(name: "days", value: "14"),
            URLQueryItem(name: "interval", value: "daily"),
        ]
        
        self.fetch(from: components, for: HistoricalPricesResponse.self) { result in
            completion(result)
        }
    }
    
    func fetchCurrentBitCoinPrice(_ completion: @escaping (Result<CurrentPriceResponse, NetworkError>) -> Void) {
        guard var components = URLComponents(string: "https://api.coingecko.com/api/v3/simple/price") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "ids", value: "bitcoin"),
            URLQueryItem(name: "vs_currencies", value: "eur")
        ]
        
        self.fetch(from: components, for: CurrentPriceResponse.self) { result in
            completion(result)
        }
    }
}
