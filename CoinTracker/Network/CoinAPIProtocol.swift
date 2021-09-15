//
//  CoinAPIProtocol.swift
//  CoinAPI
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

protocol CoinAPIProtocol {
    func getPriceInOtherCurrencies(on dateString: String, _ completion: @escaping (Result<ForexRates, Error>) -> Void)
}
