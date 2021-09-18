//
//  CoinHistoryCellViewModel.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

final class CoinHistoryCellViewModel: Equatable {
    static func == (lhs: CoinHistoryCellViewModel, rhs: CoinHistoryCellViewModel) -> Bool {
        lhs.index == rhs.index && lhs.price == rhs.price
    }
    
    private var index: Int
    private var price: Double
    
    init(index: Int, price: Double) {
        self.index = index
        self.price = price
    }
    
    var priceInEuros: Double {
        price
    }
    
    var formattedPriceString: String {
        String(format: "%.2f€", price)
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        guard let previousDate = Calendar.current.date(byAdding: .day, value: -(index), to: Date()) else {
            return ""
        }
        return dateFormatter.string(from: previousDate)
    }
}
