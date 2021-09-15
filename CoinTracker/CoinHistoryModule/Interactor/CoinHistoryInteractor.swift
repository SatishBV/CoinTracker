//
//  CoinHistoryInteractor.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

class CoinHistoryInteractor: PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    
    func fetchHistoricalPrices() {
        var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart")!
        
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "eur"),
            URLQueryItem(name: "days", value: "14"),
            URLQueryItem(name: "interval", value: "daily"),
        ]
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil {
                self.presenter?.historicalPricesFetchFailed()
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200 ..< 300 ~= response.statusCode
            else {
                self.presenter?.historicalPricesFetchFailed()
                return
            }
            
            do {
                let response = try JSONDecoder().decode(HistoricalPricesResponse.self, from: data)
                self.presenter?.historicalPricesFetchedSuccess(prices: response.pastPrices)
                return
            } catch {
                self.presenter?.historicalPricesFetchFailed()
                return
            }
        }
        
        task.resume()
    }
    
    func fetchCurrentBitCoinPrice() {
        guard var components = URLComponents(string: "https://api.coingecko.com/api/v3/simple/price") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "ids", value: "bitcoin"),
            URLQueryItem(name: "vs_currencies", value: "eur")
        ]
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil {
                self.presenter?.currentBitCoinPriceFetchFailed()
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200 ..< 300 ~= response.statusCode
            else {
                self.presenter?.currentBitCoinPriceFetchFailed()
                return
            }
            
            do {
                let resp = try JSONDecoder().decode(CurrentPriceResponse.self, from: data)
                self.presenter?.currentBitCoinPriceFetchSuccess(price: resp.bitcoin.eur)
                return
            } catch {
                self.presenter?.currentBitCoinPriceFetchFailed()
                return
            }
        }
        
        task.resume()
    }
}
