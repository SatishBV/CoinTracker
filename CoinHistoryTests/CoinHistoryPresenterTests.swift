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
        func refreshTableView() {
            
        }
        
        func showError(message: String) {
            
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
        static func createModule() -> UIViewController {
            return UIViewController()
        }
        
        func pushToPriceDetailsScreen(navigationConroller: UINavigationController, baseEuroPrice: Double, dateString: String) {
            
        }
    }
    
    var mockInteractor: MockInteractor!
    var mockRouter: MockRouter!
    var mockView: MockViewController!
    var sut: CoinHistoryPresenter!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockInteractor()
        mockRouter = MockRouter()
        mockView = MockViewController()
        
        sut = CoinHistoryPresenter(interactor: mockInteractor, router: mockRouter)
        sut.view = mockView
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchHistoricalPrices() {
        sut.fetchHistoricalPrices()
        
        
    }
}
