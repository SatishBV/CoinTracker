//
//  CoinHistoryInteractor.swift
//  CoinHistoryTests
//
//  Created by Satish Bandaru on 18/09/21.
//

import XCTest
import Utilities
@testable import CoinHistory

class CoinHistoryInteractorTests: XCTestCase {
    var sut: CoinHistoryInteractor!
    
    class MockPresenter: InteractorToPresenterProtocol {
        var errorMessage: String?
        var historicalPricesFetched: [Double]?
        var currentBitcoinPrice: Double?
        
        func historicalPricesFetchedSuccess(prices: [Double]) {
            self.historicalPricesFetched = prices
        }
        
        func currentBitCoinPriceFetchSuccess(price: Double) {
            self.currentBitcoinPrice = price
        }
        
        func networkingError(_ errorMessage: String) {
            self.errorMessage = errorMessage
        }
    }
    
    private var mockPresenter: MockPresenter!
    private var fakeService: FakeCoinGeckoService!
    
    override func setUp() {
        mockPresenter = MockPresenter()
        fakeService = FakeCoinGeckoService()
        
        sut = CoinHistoryInteractor(coinGeckoService: fakeService)
        sut.presenter = mockPresenter
    }
    
    func testFetchHistoricalPrices_ApiError() {
        fakeService.testType = .apiFailure
        
        sut.fetchHistoricalPrices()
        XCTAssertNotNil(mockPresenter.errorMessage)
        XCTAssertTrue(mockPresenter.errorMessage == NetworkError.invalidResponse.errorDescription)
    }
    
    func testFetchHistoricalPrices_Success() {
        fakeService.testType = .success
        
        sut.fetchHistoricalPrices()
        XCTAssertNotNil(mockPresenter.historicalPricesFetched)
        XCTAssertTrue(mockPresenter.historicalPricesFetched?.count == 15)
        XCTAssertEqual(mockPresenter.historicalPricesFetched?.first, 43495.171939260115)
        XCTAssertEqual(mockPresenter.historicalPricesFetched?.last, 40844.015297286875)
    }
    
    func testFetchCurrentBitCoinPrice_ApiError() {
        fakeService.testType = .apiFailure
        
        sut.fetchCurrentBitCoinPrice()
        XCTAssertNotNil(mockPresenter.errorMessage)
        XCTAssertTrue(mockPresenter.errorMessage == NetworkError.invalidResponse.errorDescription)
    }
    
    func testFetchCurrentBitCoinPrice_Success() {
        fakeService.testType = .success
        
        sut.fetchCurrentBitCoinPrice()
        XCTAssertNotNil(mockPresenter.currentBitcoinPrice)
        XCTAssertEqual(mockPresenter.currentBitcoinPrice, 40861)
    }
}
