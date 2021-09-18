//
//  CurrentPriceResponse.swift
//  CoinTracker
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

struct CurrentPriceResponse: Decodable {
    let bitcoin: BitCoinResponse
    
    struct BitCoinResponse: Decodable {
        let eur: Double
    }
}
