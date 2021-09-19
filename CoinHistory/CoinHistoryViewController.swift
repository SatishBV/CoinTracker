//
//  CoinHistoryViewController.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import UIKit
import Utilities

final class CoinHistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var presenter: ViewToPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Coin history"
        
        tableView.tableFooterView = UIView()
        tableView.backgroundView = spinner
        spinner.hidesWhenStopped = true
        
        toggleSpinner(loading: true)
        presenter?.fetchHistoricalPrices()
    }
    
    /// Shows spinner when the historical prices are still being fetched
    /// - Parameter loading: Shows spinner when true. Hides and stops when false
    func toggleSpinner(loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            loading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
        }
    }
}

extension CoinHistoryViewController: PresenterToViewProtocol {
    /// Reloads the tableview whenever the presenter says so
    func refreshTableView() {
        toggleSpinner(loading: false)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    /// When the presenter says there has been an error, it stops the spinner and displays an alert
    /// - Parameter message: Message shown in the alert
    func showError(message: String) {
        toggleSpinner(loading: false)
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: nil, message: message)
        }
    }
}

extension CoinHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let navController = navigationController {
            presenter?.showPriceDetails(index: indexPath.row, navigationController: navController)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CoinHistoryTableViewCell.self))
                as? CoinHistoryTableViewCell else {
            fatalError("Unable to instantiate cell for coin history")
        }
        
        if let cellViewModel = presenter?[indexPath.row] {
            cell.configure(for: cellViewModel)
        }
        
        return cell
    }
}
