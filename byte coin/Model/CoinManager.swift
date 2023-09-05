//
//  CoinManager.swift
//  byte coin
//
//  Created by Farid Hamzayev on 05.09.23.
//

import Foundation

protocol CoinManagerDelegate {
  func didReceivedData(_ coinManager: CoinManager, _ currency: String, _ rate: Double)
  func didFailWithError(error: Error)
}

struct CoinManager {
  let baseUrl = "https://rest.coinapi.io/v1/exchangerate/BTC"
  let apiKey = ProcessInfo.processInfo.environment["COIN_API_KEY"] ?? "API_KEY"
  let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
  
  var delegate: CoinManagerDelegate?
  
  func getCoinPrice(for currency: String) {
    let urlString = "\(baseUrl)/\(currency)?apiKey=\(apiKey)"

    if let url = URL(string: urlString) {
      
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) {(data, response, error) in
        if (error != nil) {
          return
        }

        if let safeData = data {
          if let rate = self.parseJSON(safeData) {
            self.delegate?.didReceivedData(self, currency, rate)
          }
        }
      }
      task.resume()
    }
  }
  
  func performRequest(with urlString: String) {
  }
  
  func parseJSON(_ data: Data) -> Double? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(CoinData.self, from: data)
      return decodedData.rate
    } catch {
      self.delegate?.didFailWithError(error: error)
      return nil
    }
  }
}
