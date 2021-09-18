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
        
        func historicalPricesFetchedSuccess(prices: [Double]) {
            
        }
        
        func currentBitCoinPriceFetchSuccess(price: Double) {
            
        }
        
        func networkingError(_ errorMessage: String) {
            self.errorMessage = errorMessage
        }
    }
    
    class FakeCoinGeckoService: CoinGeckoProtocol {
        // TODO: Add success test type and stub a successful JSON result
        enum TestType {
            case parseFailure
        }
        
        var testType: TestType = .parseFailure
        
        func fetchHistoricalPrices(_ completion: @escaping (Result<HistoricalPricesResponse, NetworkError>) -> Void) {
            switch testType {
            case .parseFailure:
                completion(.failure(.parsingError))
            }
        }
        
        func fetchCurrentBitCoinPrice(_ completion: @escaping (Result<CurrentPriceResponse, NetworkError>) -> Void) {
            switch testType {
            case .parseFailure:
                completion(.failure(.parsingError))
            }
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
    
    func testFetchHistoricalPrices_ParseError() {
        fakeService.testType = .parseFailure
        
        sut.fetchHistoricalPrices()
        XCTAssertNotNil(mockPresenter.errorMessage)
        XCTAssertTrue(mockPresenter.errorMessage == "Unable to parse the response")
    }
}
