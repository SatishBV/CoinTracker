//
//  CoinHistoryProtocol.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: AnyObject {
    var view: PresenterToViewProtocol? { get set }
    var interactor: PresenterToInteractorProtocol? { get set }
    var router: PresenterToRouterProtocol? { get set }
    var numberOfRows: Int { get }
    
    subscript(index: Int) -> CoinHistoryCellViewModel? { get }
    
    func fetchHistoricalPrices()
    func showPriceDetails(index: Int, navigationController: UINavigationController)
}

protocol PresenterToViewProtocol: AnyObject {
    func refreshTableView()
    func showError()
}

protocol PresenterToRouterProtocol: AnyObject {
    static func createModule() -> CoinHistoryViewController
    func pushToPriceDetailsScreen(navigationConroller: UINavigationController,
                                  baseEuroPrice: Double,
                                  dateString: String)
}

protocol PresenterToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
    
    func fetchHistoricalPrices()
    func fetchCurrentBitCoinPrice()
}

protocol InteractorToPresenterProtocol: AnyObject {
    func historicalPricesFetchedSuccess(prices: [Double])
    func historicalPricesFetchFailed()
    func currentBitCoinPriceFetchSuccess(price: Double)
    func currentBitCoinPriceFetchFailed()
}
