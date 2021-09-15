//
//  PriceDetailViewModel.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

protocol PriceDetailViewModelProtocol: AnyObject {
    func toggleLoading(_ load: Bool)
    func refreshCurrencyText()
}

final class PriceDetailViewModel {
    private var apiService: CoinAPIProtocol
    private var baseEuroPrice: Double
    private var dateString: String
    
    private weak var delegate: PriceDetailViewModelProtocol?
    
    init(
        baseEuroPrice: Double,
        dateString: String,
        delegate: PriceDetailViewModelProtocol? = nil,
        apiService: CoinAPIProtocol = CoinAPIService()
    ) {
        self.baseEuroPrice = baseEuroPrice
        self.dateString = dateString
        self.delegate = delegate
        self.apiService = apiService
    }
    
    private var currencyPrices: (usDollars: Double, gbPounds: Double) = (.zero, .zero) {
        didSet {
            delegate?.refreshCurrencyText()
        }
    }
    
    var usDollarsText: String {
        String(format: "USD: %.2f$", currencyPrices.usDollars)
    }
    
    var gbPoundsText: String {
        String(format: "GBP: %.2f£", currencyPrices.gbPounds)
    }
    
    var eurosText: String {
        String(format: "EUR: %.2f€", baseEuroPrice)
    }
    
    func loadForexPrices() {
        delegate?.toggleLoading(true)
        apiService.getPriceInOtherCurrencies(on: dateString) { [weak self] result in
            guard let self = self else { return }
            self.delegate?.toggleLoading(false)
            
            switch result {
            case let .success(response):
                print(response)
                let usdPrice: Double = self.baseEuroPrice * response.usd
                let gbpPrice: Double = self.baseEuroPrice * response.gbp
                self.currencyPrices = (usdPrice, gbpPrice)
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
