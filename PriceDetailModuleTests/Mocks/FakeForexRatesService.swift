//
//  FakeForexRatesService.swift
//  PriceDetailModuleTests
//
//  Created by Satish Bandaru on 19/09/21.
//

import Foundation
import Utilities
@testable import PriceDetailModule

class FakeForexRatesService: ForexRatesProtocol {
    enum TestType {
        case success
        case apiFailure
    }
    
    var testType: TestType = .apiFailure
    
    func forexRates(for dateString: String, _ completion: @escaping (Result<ForexConversionResponse, NetworkError>) -> Void) {
        switch testType {
        case .apiFailure:
            completion(.failure(.invalidResponse))
        case .success:
            do {
                let data = getData(fileName: "ForexConversionSuccessResponse")
                let response = try JSONDecoder().decode(ForexConversionResponse.self, from: data)
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
