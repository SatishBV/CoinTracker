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
    func showError(message: String)
}

protocol PresenterToRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
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
    func currentBitCoinPriceFetchSuccess(price: Double)
    func networkingError(_ errorMessage: String)
}
