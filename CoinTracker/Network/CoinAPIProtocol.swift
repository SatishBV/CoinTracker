//
//  CoinAPIProtocol.swift
//  CoinAPI
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

protocol CoinAPIProtocol {
    func getPastPrices(_ completion: @escaping (Result<HistoricalPricesResponse, Error>) -> Void)
    func getPriceInOtherCurrencies(on dateString: String, _ completion: @escaping (Result<ForexRates, Error>) -> Void)
    func getCurrentPriceInEuros(_ completion: @escaping (Result<Double, Error>) -> Void)
}
