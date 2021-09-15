//
//  PriceDetailInteractor.swift
//  PriceDetailModule
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

class PriceDetailInteractor: PresenterToInteractorProtocol {
    weak var presenter: InteractorToPresenterProtocol?
    
    func fetchForexRates(for dateString: String) {
        // TODO: Prevent API call as it might run out of limit
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presenter?.fetchForexRatesSuccess(rates: ForexRates(usd: 1.182306, gbp: 0.855735))
        }
        return
        
        guard var components = URLComponents(string: "http://api.exchangeratesapi.io/v1/\(dateString)") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "access_key", value: "3c00fe4ecb3d4008c90006528d53245d"),
            URLQueryItem(name: "symbols", value: "USD,GBP")
        ]
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if error != nil {
                self.presenter?.fetchForexRatesFailed()
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200 ..< 300 ~= response.statusCode
            else {
                self.presenter?.fetchForexRatesFailed()
                return
            }
            
            do {
                let resp = try JSONDecoder().decode(ForexConversionResponse.self, from: data)
                self.presenter?.fetchForexRatesSuccess(rates: resp.rates)
                return
            } catch {
                self.presenter?.fetchForexRatesFailed()
                return
            }
        }
        
        task.resume()
    }
}
