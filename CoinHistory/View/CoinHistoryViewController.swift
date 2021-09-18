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
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Coin history"
        
        tableView.tableFooterView = UIView()
        tableView.backgroundView = spinner
        spinner.hidesWhenStopped = true
        
        toggleSpinner(loading: true)
        presenter?.fetchHistoricalPrices()
    }
    
    func toggleSpinner(loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            loading ? self?.spinner.startAnimating() : self?.spinner.stopAnimating()
        }
    }
}

extension CoinHistoryViewController: PresenterToViewProtocol {
    func refreshTableView() {
        toggleSpinner(loading: false)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
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
