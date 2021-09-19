//
//  FakeCoinGeckoService.swift
//  CoinHistoryTests
//
//  Created by Satish Bandaru on 19/09/21.
//

import Foundation
import Utilities
@testable import CoinHistory

class FakeCoinGeckoService: CoinGeckoProtocol {
    enum TestType {
        case success
        case apiFailure
    }
    
    var testType: TestType = .apiFailure
    
    func fetchHistoricalPrices(_ completion: @escaping (Result<HistoricalPricesResponse, NetworkError>) -> Void) {
        switch testType {
        case .apiFailure:
            completion(.failure(.invalidResponse))
        case .success:
            do {
                let data = getData(fileName: "HistoricalPricesSuccessResponse")
                let response = try JSONDecoder().decode(HistoricalPricesResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.parsingError))
            }
        }
    }
    
    func fetchCurrentBitCoinPrice(_ completion: @escaping (Result<CurrentPriceResponse, NetworkError>) -> Void) {
        switch testType {
        case .apiFailure:
            completion(.failure(.invalidResponse))
            
        case .success:
            do {
                let data = getData(fileName: "CurrentBitcoinPriceResponse")
                let response = try JSONDecoder().decode(CurrentPriceResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.parsingError))
            }
        }
    }

    private func getData(fileName: String, withExtension: String = "json") -> Data {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: fileName, withExtension: withExtension)
        let data = try! Data(contentsOf: fileUrl!)
        return data
    }
}
