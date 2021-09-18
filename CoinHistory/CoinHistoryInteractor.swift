//
//  CoinHistoryInteractor.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

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
    
    var coinGeckoClient: CoinGeckoProtocol
    
    init(
        coinGeckoClient: CoinGeckoProtocol = CoinGeckoService()
    ) {
        self.coinGeckoClient = coinGeckoClient
    }
    
    func fetchHistoricalPrices() {
        coinGeckoClient.fetchHistoricalPrices { [weak self] result in
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
        coinGeckoClient.fetchCurrentBitCoinPrice { [weak self] result in
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
