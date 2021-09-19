//
//  CoinHistoryTableViewCell.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import UIKit

final class CoinHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(for viewModel: CoinHistoryCellViewModel) {
        dateLabel.text = viewModel.dateString()
        priceLabel.text = viewModel.formattedPriceString
    }
}
