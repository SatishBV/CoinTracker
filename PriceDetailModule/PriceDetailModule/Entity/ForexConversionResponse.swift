//
//  ForexConversionResponse.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

struct ForexConversionResponse: Decodable {
    var rates: ForexRates
}

struct ForexRates: Decodable {
    var usd: Double
    var gbp: Double
    
    init(usd: Double, gbp: Double) {
        self.usd = usd
        self.gbp = gbp
    }
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
        case gbp = "GBP"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.usd = try container.decode(Double.self, forKey: .usd)
        self.gbp = try container.decode(Double.self, forKey: .gbp)
    }
}
