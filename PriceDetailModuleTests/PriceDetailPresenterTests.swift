//
//  PriceDetailPresenterTests.swift
//  PriceDetailModuleTests
//
//  Created by Satish Bandaru on 19/09/21.
//

import XCTest
import Utilities
@testable import PriceDetailModule

class PriceDetailPresenterTests: XCTestCase {
    var mockInteractor: MockInteractor!
    var mockRouter: MockRouter!
    var mockView: MockViewController!
    var sut: PriceDetailPresenter!
    
    override func setUp() {
        super.setUp()
        
        mockInteractor = MockInteractor()
        mockRouter = MockRouter()
        mockView = MockViewController()
        
        sut = PriceDetailPresenter(
            baseEuroPrice: 40000,
            dateString: "2021-09-08",
            interactor: mockInteractor,
            router: mockRouter
        )
        sut.view = mockView
    }
    
    func testNetworkError() {
        sut.networkError(NetworkError.invalidResponse.errorDescription)
        
        XCTAssertNotNil(mockView.errorMessage)
        XCTAssertTrue(mockView.errorMessage == NetworkError.invalidResponse.errorDescription)
    }
    
    func testFetchForexRatesSuccess() {
        let mockRates = ForexRates(usd: 1.2, gbp: 0.8)
        sut.fetchForexRatesSuccess(rates: mockRates)
        
        XCTAssertTrue(mockView.refreshedCurrencyText)
    }
    
    func testUsDollarsText() {
        let mockRates = ForexRates(usd: 1.2, gbp: 0.8)
        sut.fetchForexRatesSuccess(rates: mockRates)
        XCTAssertTrue(sut.usDollarsText == "USD: 48000.00$")
    }
    
    func testGbPoundsText() {
        let mockRates = ForexRates(usd: 1.2, gbp: 0.8)
        sut.fetchForexRatesSuccess(rates: mockRates)
        XCTAssertTrue(sut.gbPoundsText == "GBP: 32000.00£")
    }
    
    func testEurosText() {
        let mockRates = ForexRates(usd: 1.2, gbp: 0.8)
        sut.fetchForexRatesSuccess(rates: mockRates)
        XCTAssertTrue(sut.eurosText == "EUR: 40000.00€")
    }
    
    func testDateText() {
        XCTAssertTrue(sut.dateText == "Date: 2021-09-08")
    }
    
    func testFetchForexRates() {
        sut.fetchForexRates()
        XCTAssertTrue(mockInteractor.shouldFetchForexRates)
    }
}

class MockViewController: PresenterToViewProtocol {
    var errorMessage: String?
    var refreshedCurrencyText: Bool = false
    
    func refreshCurrencyText() {
        refreshedCurrencyText = true
    }
    
    func showAlert(_ message: String) {
        errorMessage = message
    }
}

class MockInteractor: PresenterToInteractorProtocol {
    weak var presenter: InteractorToPresenterProtocol?
    
    var shouldFetchForexRates: Bool = false
    
    func fetchForexRates(for dateString: String) {
        shouldFetchForexRates = true
    }
}

class MockRouter: PresenterToRouterProtocol {}
