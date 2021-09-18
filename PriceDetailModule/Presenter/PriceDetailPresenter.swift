//
//  PriceDetailPresenter.swift
//  PriceDetailModule
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

protocol ViewToPresenterProtocol: AnyObject {
    var view: PresenterToViewProtocol? { get set }
    var interactor: PresenterToInteractorProtocol? { get set }
    var router: PresenterToRouterProtocol? { get set }
    var usDollarsText: String { get }
    var gbPoundsText: String { get }
    var eurosText: String { get }
    var dateText: String { get }
    
    func fetchForexRates()
}

protocol InteractorToPresenterProtocol: AnyObject {
    func fetchForexRatesSuccess(rates: ForexRates)
    func networkError(_ errorMessage: String)
}

class PriceDetailPresenter: ViewToPresenterProtocol {
    weak var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    
    private var baseEuroPrice: Double
    private var dateString: String
    
    init(
        baseEuroPrice: Double,
        dateString: String
    ) {
        self.baseEuroPrice = baseEuroPrice
        self.dateString = dateString
    }
    
    private var currencyPrices: (usDollars: Double, gbPounds: Double) = (.zero, .zero) {
        didSet {
            view?.refreshCurrencyText()
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
    
    var dateText: String {
        String("Date: \(dateString)")
    }
    
    func fetchForexRates() {
        interactor?.fetchForexRates(for: dateString)
    }
}

extension PriceDetailPresenter: InteractorToPresenterProtocol {
    func fetchForexRatesSuccess(rates: ForexRates) {
        let usdPrice: Double = self.baseEuroPrice * rates.usd
        let gbpPrice: Double = self.baseEuroPrice * rates.gbp
        self.currencyPrices = (usdPrice, gbpPrice)
    }
    
    func networkError(_ errorMessage: String) {
        view?.showAlert(errorMessage)
    }
}
