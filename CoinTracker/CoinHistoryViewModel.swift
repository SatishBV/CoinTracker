//
//  CoinHistoryViewModel.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

protocol CoinHistoryViewModelProtocol: AnyObject {
    func refreshData()
}


class CoinHistoryViewModel {
    var apiService: CoinAPIProtocol
    weak var delegate: CoinHistoryViewModelProtocol?
    
    var historicPrices: [Double] = [] {
        didSet {
            delegate?.refreshData()
        }
    }
    
    init(
        apiService: CoinAPIProtocol = CoinAPIService(),
        delegate: CoinHistoryViewModelProtocol
    ) {
        self.apiService = apiService
        self.delegate = delegate
    }
    
    func getHistoricalData() {
        apiService.getPastPrices { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response):
                print(response.pastPrices)
                self.historicPrices = response.pastPrices
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getForexRates() {
        apiService.getPriceInOtherCurrencies(on: Date()) { result in
            switch result {
            case let .success(response):
                print(response)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
