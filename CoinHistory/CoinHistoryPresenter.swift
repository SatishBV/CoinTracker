//
//  CoinHistoryPresenter.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: AnyObject {
    var view: PresenterToViewProtocol? { get set }
    var numberOfRows: Int { get }
    
    subscript(index: Int) -> CoinHistoryCellViewModel? { get }
    
    func fetchHistoricalPrices()
    func showPriceDetails(index: Int, navigationController: UINavigationController)
}

protocol PresenterToViewProtocol: AnyObject {
    func refreshTableView()
    func showError(message: String)
}

class CoinHistoryPresenter: ViewToPresenterProtocol {
    weak var view: PresenterToViewProtocol?
    private var interactor: PresenterToInteractorProtocol
    private var router: PresenterToRouterProtocol
    private let priceRefreshQueue: DispatchQueueType
    private var timer: Timer?
    
    init(
        interactor: PresenterToInteractorProtocol,
        router: PresenterToRouterProtocol,
        priceRefreshQueue: DispatchQueueType = DispatchQueue(label: "currentPriceQueue:\(UUID().uuidString)")
    ) {
        self.interactor = interactor
        self.router = router
        self.priceRefreshQueue = priceRefreshQueue
    }
    
    private var historicalPrices: [Double] = [] {
        didSet {
            view?.refreshTableView()
        }
    }
    
    /// The view knows how many rows to show in the tableview based on this
    var numberOfRows: Int {
        historicalPrices.count
    }
    
    /// Utility method to get a viewModel for each cell in the tableview using index.
    subscript(index: Int) -> CoinHistoryCellViewModel? {
        guard 0..<historicalPrices.count ~= index else { return nil }
        return CoinHistoryCellViewModel(index: index, price: historicalPrices[index])
    }
    
    /// Asks the interactor to fetch historical prices
    func fetchHistoricalPrices() {
        interactor.fetchHistoricalPrices()
    }
    
    /// Shows the price details for a particular day that user selects
    /// - Parameters:
    ///   - index: Index of the cell which user tapped. Helps in getting the date and price from that day
    ///   - navigationController: Acts as navigation controller for displaying the price details screen
    func showPriceDetails(index: Int, navigationController: UINavigationController) {
        guard let cellViewModel = self[index] else { return }
        
        router.pushToPriceDetailsScreen(
            navigationConroller: navigationController,
            baseEuroPrice: cellViewModel.priceInEuros,
            dateString: cellViewModel.dateString()
        )
    }
    
    deinit {
        /// Clear the timer object when the screen gets deinitialized.
        timer?.invalidate()
        timer = nil
    }
}

extension CoinHistoryPresenter: InteractorToPresenterProtocol {
    /// Called when the interactor notifies that the current price has been fetched successfully
    /// It then replaces the first element of the `historicalPrices` array to denote the latest value.
    /// - Parameter price: The price of the bitcoin
    func currentBitCoinPriceFetchSuccess(price: Double) {
        guard !self.historicalPrices.isEmpty else {
            historicalPrices.append(price)
            return
        }
        
        self.historicalPrices[0] = price
        print("Current price: ",price)
    }
    
    /// Called when the interactor notifies that the API call has failed due to some error
    /// - Parameter errorMessage: Message that the view has to display
    func networkingError(_ errorMessage: String) {
        view?.showError(message: errorMessage)
    }
    
    /// Called when the interactor notifies that historical prices of the bitcoin have been fetched successfully
    /// Also, Starts the 60s timer
    /// - Parameter prices: Array of prices that have to be shown on the tableview
    func historicalPricesFetchedSuccess(prices: [Double]) {
        self.historicalPrices = prices
        self.beginTimer()
    }
}

extension CoinHistoryPresenter {
    /// Whenever timer finishes 60s, this method is called to fetch the new current bitcoin price from the interactor
    @objc func getCurrentBitCoinPrice() {
        /// Fetch the price on current price queue to avoid hogging up other threads
        priceRefreshQueue.async { [weak self] in
            self?.interactor.fetchCurrentBitCoinPrice()
        }
    }
    
    /// Begins timer and calls `getCurrentBitCoinPrice` every 60s
    private func beginTimer() {
        /// Make sure timer is nil before starting it
        guard timer == nil else { return }
        
        /// Start the timer on main thread, as Timer needs a run-loop.
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(60.0), repeats: true) { _ in
                self.getCurrentBitCoinPrice()
            }
        }
    }
}

protocol DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void)
}
 
extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}
