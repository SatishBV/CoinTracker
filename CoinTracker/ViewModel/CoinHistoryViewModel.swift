//
//  CoinHistoryViewModel.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

protocol CoinHistoryViewModelProtocol: AnyObject {
    func refreshData()
    func toggleLoading(_ load: Bool)
}

final class CoinHistoryViewModel {
    private var apiService: CoinAPIProtocol
    private weak var delegate: CoinHistoryViewModelProtocol?
    
    private var historicPrices: [Double] = [] {
        didSet {
            delegate?.refreshData()
        }
    }
    
    var numberOfRows: Int {
        historicPrices.count
    }
    
    init(
        apiService: CoinAPIProtocol = CoinAPIService(),
        delegate: CoinHistoryViewModelProtocol
    ) {
        self.apiService = apiService
        self.delegate = delegate
    }
    
    subscript(index: Int) -> CoinHistoryCellViewModel? {
        guard 0..<historicPrices.count ~= index else { return nil }
        return CoinHistoryCellViewModel(index: index, price: historicPrices[index])
    }
    
    func getHistoricalData() {
        delegate?.toggleLoading(true)
        apiService.getPastPrices { [weak self] result in
            guard let self = self else { return }
            self.delegate?.toggleLoading(false)
            switch result {
            case let .success(response):
                print(response.pastPrices)
                self.historicPrices = response.pastPrices
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getCurrentBitCoinPrice() {
        apiService.getCurrentPriceInEuros { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(price):
                guard !self.historicPrices.isEmpty else {
                    self.historicPrices.append(price)
                    return
                }
                self.historicPrices[0] = price
                print("Current price: ",price)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
