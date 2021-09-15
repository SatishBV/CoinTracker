//
//  PriceDetailViewController.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import UIKit

final class PriceDetailViewController: UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usDollarLabel: UILabel!
    @IBOutlet weak var gbPoundLabel: UILabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var eurosLabel: UILabel!
    
    var viewModel: PriceDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Forex Prices"
        viewModel.loadForexPrices()
    }
}

extension PriceDetailViewController: PriceDetailViewModelProtocol {
    func toggleLoading(_ load: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.detailsStackView.isHidden = load
            load ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
        }
    }
    
    func refreshCurrencyText() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.usDollarLabel.text = self.viewModel.usDollarsText
            self.gbPoundLabel.text = self.viewModel.gbPoundsText
            self.eurosLabel.text = self.viewModel.eurosText
        }
    }
}
