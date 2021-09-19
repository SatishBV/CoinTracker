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
    
    let forexRatesService: ForexRatesProtocol
    
    init(
        forexRatesService: ForexRatesProtocol = ForexRatesService()
    ) {
        self.forexRatesService = forexRatesService
    }
    
    func fetchForexRates(for dateString: String) {
        forexRatesService.forexRates(for: dateString) { [weak self] result in
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
