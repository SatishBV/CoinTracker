//
//  HistoricalPricesResponse.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

struct HistoricalPricesResponse: Decodable {
    let pastPrices: [Double]
    
    enum CodingKeys: String, CodingKey {
        case prices
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let prices = try container.decode([[Double]].self, forKey: .prices)
        self.pastPrices = prices.compactMap { $0[1] }
    }
}
