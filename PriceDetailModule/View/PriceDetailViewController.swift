//
//  PriceDetailViewController.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import UIKit
import Utilities

public final class PriceDetailViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usDollarLabel: UILabel!
    @IBOutlet weak var gbPoundLabel: UILabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var eurosLabel: UILabel!
    
    var presenter: ViewToPresenterProtocol?
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Forex Prices"
        toggleSpinner(loading: true)
        presenter?.fetchForexRates()
    }
    
    func toggleSpinner(loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            loading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
            self?.detailsStackView.isHidden = loading
        }
    }
}

extension PriceDetailViewController: PresenterToViewProtocol {
    func refreshCurrencyText() {
        toggleSpinner(loading: false)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dateLabel.text = self.presenter?.dateText
            self.usDollarLabel.text = self.presenter?.usDollarsText
            self.gbPoundLabel.text = self.presenter?.gbPoundsText
            self.eurosLabel.text = self.presenter?.eurosText
        }
    }
    
    func showError() {
        print("Error")
        toggleSpinner(loading: false)
    }
    
    func showAlert(_ message: String) {
        toggleSpinner(loading: false)
        showAlert(title: nil, message: message)
    }
}
