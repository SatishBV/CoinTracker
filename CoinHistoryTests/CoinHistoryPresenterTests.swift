//
//  CoinHistoryPresenterTests.swift
//  CoinHistoryTests
//
//  Created by Satish Bandaru on 18/09/21.
//

import XCTest
import UIKit
@testable import CoinHistory

class CoinHistoryPresenterTests: XCTestCase {
    class MockViewController: PresenterToViewProtocol {
        var errorMessage: String?
        
        func refreshTableView() {
            
        }
        
        func showError(message: String) {
            errorMessage = message
        }
    }
    
    class MockInteractor: PresenterToInteractorProtocol {
        weak var presenter: InteractorToPresenterProtocol?
        
        var shouldFetchHistoricalPrices: Bool = false
        var shouldFetchCurrentBitCoinPrice: Bool = false
        
        func fetchHistoricalPrices() {
            shouldFetchHistoricalPrices = true
        }
        
        func fetchCurrentBitCoinPrice() {
            shouldFetchCurrentBitCoinPrice = true
        }
    }
    
    class MockRouter: PresenterToRouterProtocol {
        var baseEuroPrice: Double?
        var dateString: String?
        
        static func createModule() -> UIViewController {
            return UIViewController()
        }
        
        func pushToPriceDetailsScreen(navigationConroller: UINavigationController, baseEuroPrice: Double, dateString: String) {
            self.baseEuroPrice = baseEuroPrice
            self.dateString = dateString
        }
    }
    
    var mockInteractor: MockInteractor!
    var mockRouter: MockRouter!
    var mockView: MockViewController!
    var sut: CoinHistoryPresenter!
    
    override func setUp() {
        super.setUp()
        let fakeQueue = DispatchQueueFake()
        mockInteractor = MockInteractor()
        mockRouter = MockRouter()
        mockView = MockViewController()
        
        sut = CoinHistoryPresenter(interactor: mockInteractor, router: mockRouter, priceRefreshQueue: fakeQueue)
        sut.view = mockView
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNumberOfRows() {
        sut.historicalPricesFetchedSuccess(prices: [1.0, 2.0, 3.3, 4.4])
        XCTAssertEqual(sut.numberOfRows, 4)
        
        sut.historicalPricesFetchedSuccess(prices: [])
        XCTAssertEqual(sut.numberOfRows, 0)
    }
    
    func testFetchHistoricalPrices() {
        sut.fetchHistoricalPrices()
        
        XCTAssertTrue(mockInteractor.shouldFetchHistoricalPrices)
        XCTAssertFalse(mockInteractor.shouldFetchCurrentBitCoinPrice)
    }
    
    func testGetCurrentBitCoinPrice() {
        sut.getCurrentBitCoinPrice()
        
        XCTAssertTrue(mockInteractor.shouldFetchCurrentBitCoinPrice)
        XCTAssertFalse(mockInteractor.shouldFetchHistoricalPrices)
    }
    
    func testGetCellViewModel_usingSubscript() {
        sut.historicalPricesFetchedSuccess(prices: [1.0, 2.0, 3.3, 4.4])
        
        XCTAssertNil(sut[-1])
        XCTAssertNil(sut[5])
        XCTAssertNotNil(sut[3])
        
        XCTAssertEqual(sut[0], CoinHistoryCellViewModel(index: 0, price: 1.0))
    }
    
    func testCurrentBitCoinPrice_fetchSuccessWhenPrevResultsPresent() {
        sut.historicalPricesFetchedSuccess(prices: [1.0, 2.0, 3.3, 4.4])
        sut.currentBitCoinPriceFetchSuccess(price: 2000.0)
        
        XCTAssertEqual(sut[0], CoinHistoryCellViewModel(index: 0, price: 2000.0))
        XCTAssertEqual(sut[1], CoinHistoryCellViewModel(index: 1, price: 2.0))
    }
    
    func testCurrentBitCoinPrice_fetchSuccessWhenPrevResultsNotPresent() {
        sut.historicalPricesFetchedSuccess(prices: [])
        sut.currentBitCoinPriceFetchSuccess(price: 2000.0)
        
        XCTAssertEqual(sut[0], CoinHistoryCellViewModel(index: 0, price: 2000.0))
        XCTAssertNil(sut[1])
    }
    
    func testNetworkingError() {
        sut.networkingError("Something wrong")
        XCTAssertTrue(mockView.errorMessage == "Something wrong")
    }
    
    func testShowPriceDetailsForValidIndex() {
        sut.historicalPricesFetchedSuccess(prices: [1.0, 2.0, 3.3, 4.4])
        sut.showPriceDetails(index: 0, navigationController: UINavigationController())
        
        let dateString: String? = sut[0]?.dateString()
        XCTAssertEqual(mockRouter.baseEuroPrice, 1.0)
        XCTAssertEqual(mockRouter.dateString, dateString)
    }
    
    func testShowPriceDetailsForInvalidIndex() {
        sut.historicalPricesFetchedSuccess(prices: [1.0, 2.0, 3.3, 4.4])
        
        sut.showPriceDetails(index: -1, navigationController: UINavigationController())
        XCTAssertEqual(mockRouter.baseEuroPrice, nil)
        XCTAssertEqual(mockRouter.dateString, nil)
        
        sut.showPriceDetails(index: 4, navigationController: UINavigationController())
        XCTAssertEqual(mockRouter.baseEuroPrice, nil)
        XCTAssertEqual(mockRouter.dateString, nil)
    }
    
    func testDeInit() {
        let _ = CoinHistoryPresenter(interactor: mockInteractor, router: mockRouter)
    }
}

final class DispatchQueueFake: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
