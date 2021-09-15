//
//  CoinAPIProtocol.swift
//  CoinAPI
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

protocol CoinAPIProtocol {
    func getPastPrices(_ completion: @escaping (Result<HistoricalPricesResponse, Error>) -> Void)
    func getPriceInOtherCurrencies(on date: Date, _ completion: @escaping (Result<ForexRates, Error>) -> Void)
}
