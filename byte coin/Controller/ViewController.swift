//
//  ViewController.swift
//  byte coin
//
//  Created by Farid Hamzayev on 05.09.23.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var bitcoinLabel: UILabel!
  @IBOutlet weak var currencyLabel: UILabel!
  @IBOutlet weak var currencyPicker: UIPickerView!
  
  var coinManager = CoinManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    currencyPicker.dataSource = self
    currencyPicker.delegate = self
    coinManager.delegate = self
  }
}

// MARK: UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return coinManager.currencies.count
  }
}

// MARK: UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return coinManager.currencies[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectedCurrency = coinManager.currencies[row]
    coinManager.getCoinPrice(for: selectedCurrency)
  }
}

// MARK: CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
  func didReceivedData(_ coinManager: CoinManager, _ currency: String, _ rate: Double) {
    DispatchQueue.main.async {
      self.bitcoinLabel.text = currency
      self.currencyLabel.text = String(format: "%.2f", rate)
    }
  }
  
  func didFailWithError(error: Error) {
    print(error)
  }
}
