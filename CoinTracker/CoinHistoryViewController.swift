//
//  CoinHistoryViewController.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import UIKit

class CoinHistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // TODO: - Try injecting via initialiser
    var viewModel: CoinHistoryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Coin history"
        
        tableView.tableFooterView = UIView()
        
        viewModel.getHistoricalData()
    }
}

extension CoinHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TODO: Navigate to details screen
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.historicPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CoinHistoryTableViewCell.self))
                as? CoinHistoryTableViewCell else {
            fatalError("Unable to instantiate cell for coin history")
        }
        let price: Double = viewModel.historicPrices[indexPath.row]
        cell.priceLabel.text = "\(price)"
        return cell
    }
}

extension CoinHistoryViewController: CoinHistoryViewModelProtocol {
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

