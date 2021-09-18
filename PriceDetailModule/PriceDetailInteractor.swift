//
//  PriceDetailInteractor.swift
//  PriceDetailModule
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

protocol InteractorToPresenterProtocol: AnyObject {
    func fetchForexRatesSuccess(rates: ForexRates)
    func networkError(_ errorMessage: String)
}

protocol PresenterToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
    
    func fetchForexRates(for dateString: String)
}

class PriceDetailInteractor: PresenterToInteractorProtocol {
    weak var presenter: InteractorToPresenterProtocol?
    
    var exchangeRatesClient: ExchangeRatesProtocol
    
    init(
        exchangeRatesClient: ExchangeRatesProtocol = ForexRatesService()
    ) {
        self.exchangeRatesClient = exchangeRatesClient
    }
    
    func fetchForexRates(for dateString: String) {
        // TODO: Prevent API call as it might run out of limit
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presenter?.fetchForexRatesSuccess(rates: ForexRates(usd: 1.182306, gbp: 0.855735))
        }
        return
        
        exchangeRatesClient.forexRates(for: dateString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.presenter?.fetchForexRatesSuccess(rates: response.rates)
            case let .failure(error):
                self.presenter?.networkError(error.errorDescription)
            }
        }
    }
}
