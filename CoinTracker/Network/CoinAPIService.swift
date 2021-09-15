//
//  CoinAPIService.swift
//  CoinAPI
//
//  Created by Satish Bandaru on 15/09/21.
//

import Foundation

class CoinAPIService: CoinAPIProtocol {
    
    func getPastPrices(_ completion: @escaping (Result<HistoricalPricesResponse, Error>) -> Void) {
        var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart")!
        
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "eur"),
            URLQueryItem(name: "days", value: "14"),
            URLQueryItem(name: "interval", value: "daily"),
        ]
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200 ..< 300 ~= response.statusCode
            else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let pastPrices = try JSONDecoder().decode(HistoricalPricesResponse.self, from: data)
                completion(.success(pastPrices))
                return
            } catch {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
        }
        
        task.resume()
    }
    
    func getPriceInOtherCurrencies(on dateString: String, _ completion: @escaping (Result<ForexRates, Error>) -> Void) {
        // TODO: Prevent API call as it might run out of limit
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(ForexRates(usd: 1.182306, gbp: 0.855735)))
        }
        return
        
        var components = URLComponents(string: "http://api.exchangeratesapi.io/v1/\(dateString)")!
        
        components.queryItems = [
            URLQueryItem(name: "access_key", value: "3c00fe4ecb3d4008c90006528d53245d"),
            URLQueryItem(name: "symbols", value: "USD,GBP")
        ]
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200 ..< 300 ~= response.statusCode
            else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let resp = try JSONDecoder().decode(ForexConversionResponse.self, from: data)
                completion(.success(resp.rates))
                return
            } catch {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
        }
        
        task.resume()
    }
    
    func getCurrentPriceInEuros(_ completion: @escaping (Result<Double, Error>) -> Void) {
        guard var components = URLComponents(string: "https://api.coingecko.com/api/v3/simple/price") else {
            return
        }
        
        components.queryItems = [
            URLQueryItem(name: "ids", value: "bitcoin"),
            URLQueryItem(name: "vs_currencies", value: "eur")
        ]
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  200 ..< 300 ~= response.statusCode
            else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let resp = try JSONDecoder().decode(CurrentPriceResponse.self, from: data)
                completion(.success(resp.bitcoin.eur))
                return
            } catch {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
        }
        
        task.resume()
    }
}

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

struct ForexConversionResponse: Decodable {
    var rates: ForexRates
}

struct CurrentPriceResponse: Decodable {
    let bitcoin: BitCoinResponse
    
    struct BitCoinResponse: Decodable {
        let eur: Double
    }
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
