//
//  PriceDetailInteractor.swift
//  PriceDetailModule
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import Utilities

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
    
    func fetchForexRates(for dateString: String) {
        // TODO: Prevent API call as it might run out of limit
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presenter?.fetchForexRatesSuccess(rates: ForexRates(usd: 1.182306, gbp: 0.855735))
        }
        return
        
        guard var components = URLComponents(string: "http://api.exchangeratesapi.io/v1/\(dateString)") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "access_key", value: "3c00fe4ecb3d4008c90006528d53245d"),
            URLQueryItem(name: "symbols", value: "USD,GBP")
        ]
        
        NetworkManager<ForexConversionResponse>.fetch(from: components) { [weak self] result in
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
