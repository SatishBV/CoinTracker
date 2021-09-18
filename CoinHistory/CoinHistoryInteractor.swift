//
//  CoinHistoryInteractor.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import Utilities

protocol PresenterToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
    
    func fetchHistoricalPrices()
    func fetchCurrentBitCoinPrice()
}

protocol InteractorToPresenterProtocol: AnyObject {
    func historicalPricesFetchedSuccess(prices: [Double])
    func currentBitCoinPriceFetchSuccess(price: Double)
    func networkingError(_ errorMessage: String)
}

class CoinHistoryInteractor: PresenterToInteractorProtocol {
    weak var presenter: InteractorToPresenterProtocol?
    
    func fetchHistoricalPrices() {
        guard var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "eur"),
            URLQueryItem(name: "days", value: "14"),
            URLQueryItem(name: "interval", value: "daily"),
        ]
        
        NetworkManager<HistoricalPricesResponse>.fetch(from: components) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.presenter?.historicalPricesFetchedSuccess(prices: response.pastPrices)
            case let .failure(error):
                self.presenter?.networkingError(error.errorDescription)
            }
        }
    }
    
    func fetchCurrentBitCoinPrice() {
        guard var components = URLComponents(string: "https://api.coingecko.com/api/v3/simple/price") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "ids", value: "bitcoin"),
            URLQueryItem(name: "vs_currencies", value: "eur")
        ]
        
        NetworkManager<CurrentPriceResponse>.fetch(from: components) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.presenter?.currentBitCoinPriceFetchSuccess(price:  response.bitcoin.eur)
            case let .failure(error):
                self.presenter?.networkingError(error.errorDescription)
            }
        }
    }
}
