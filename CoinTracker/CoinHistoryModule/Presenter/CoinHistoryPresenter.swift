//
//  CoinHistoryPresenter.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation
import UIKit

class CoinHistoryPresenter: ViewToPresenterProtocol {
    var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    private let currentPriceQueue = DispatchQueue(label: "currentPriceQueue:\(UUID().uuidString)")
    private var timer: Timer?
    
    private var historicalPrices: [Double] = [] {
        didSet {
            view?.showHistoricalPrices()
        }
    }
    
    var numberOfRows: Int {
        historicalPrices.count
    }
    
    subscript(index: Int) -> CoinHistoryCellViewModel? {
        guard 0..<historicalPrices.count ~= index else { return nil }
        return CoinHistoryCellViewModel(index: index, price: historicalPrices[index])
    }
    
    func fetchHistoricalPrices() {
        interactor?.fetchHistoricalPrices()
    }
    
    func showPriceDetails(index: Int, navigationController: UINavigationController) {
        guard let cellViewModel = self[index] else { return }
        
        router?.pushToPriceDetailsScreen(navigationConroller: navigationController,
                                         baseEuroPrice: cellViewModel.priceInEuros,
                                         dateString: cellViewModel.dateString)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

extension CoinHistoryPresenter: InteractorToPresenterProtocol {
    func currentBitCoinPriceFetchSuccess(price: Double) {
        guard !self.historicalPrices.isEmpty else {
            historicalPrices.append(price)
            return
        }
        
        self.historicalPrices[0] = price
        print("Current price: ",price)
    }
    
    func currentBitCoinPriceFetchFailed() {
        view?.showError()
    }
    
    func historicalPricesFetchedSuccess(prices: [Double]) {
        self.historicalPrices = prices
        self.beginTimer()
    }
    
    func historicalPricesFetchFailed() {
        view?.showError()
    }
}

extension CoinHistoryPresenter {
    @objc func getCurrentBitCoinPrice() {
        // Fetch the price on current price queue to avoid hogging up other threads
        currentPriceQueue.async { [weak self] in
            self?.interactor?.fetchCurrentBitCoinPrice()
        }
    }
    
    private func beginTimer() {
        // Make sure timer is nil before starting it
        guard timer == nil else { return }
        
        // Start the timer on main thread, as Timer needs a run-loop.
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(60.0), repeats: true) { _ in
                self.getCurrentBitCoinPrice()
            }
        }
    }
}
