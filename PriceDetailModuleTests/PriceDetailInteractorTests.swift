//
//  PriceDetailInteractorTests.swift
//  PriceDetailModuleTests
//
//  Created by Satish Bandaru on 19/09/21.
//

import XCTest
import Utilities
@testable import PriceDetailModule

class PriceDetailInteractorTests: XCTestCase {
    var sut: PriceDetailInteractor!
    var mockPresenter: MockPresenter!
    var fakeService: FakeForexRatesService!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockPresenter()
        fakeService = FakeForexRatesService()
        sut = PriceDetailInteractor(forexRatesService: fakeService)
        sut.presenter = mockPresenter
    }
    
    func testFetchforexRatesSuccess() {
        fakeService.testType = .success
        
        sut.fetchForexRates(for: "")
        XCTAssertNil(mockPresenter.errorMessage)
        XCTAssertNotNil(mockPresenter.forexRates)
        XCTAssertTrue(mockPresenter.forexRates?.usd == 1.180665)
        XCTAssertTrue(mockPresenter.forexRates?.gbp == 0.857138)
    }
    
    func testFetchForexRatesError() {
        fakeService.testType = .apiFailure
        
        sut.fetchForexRates(for: "")
        XCTAssertNil(mockPresenter.forexRates)
        XCTAssertNotNil(mockPresenter.errorMessage)
        XCTAssertTrue(mockPresenter.errorMessage == NetworkError.invalidResponse.errorDescription)
    }
}

class MockPresenter: InteractorToPresenterProtocol {
    var errorMessage: String?
    var forexRates: ForexRates?
    
    func fetchForexRatesSuccess(rates: ForexRates) {
        self.forexRates = rates
    }
    
    func networkError(_ errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
