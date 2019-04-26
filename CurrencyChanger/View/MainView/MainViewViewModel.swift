//
//  MainViewViewModel.swift
//  CurrencyChanger
//
//  Created by Bartosz Nowacki on 14/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

enum ViewMode {
    case normal
    case addCurrency
}

class MainViewViewModel: MainViewModelProtocol {
    
    var currencies: Currencies?
    let baseCurrency: Dynamic<Currency>
    let currencyRates: Dynamic<[Currency]?>
    let navTitle: Dynamic<String>
    var markedCurrenciesList = ["USD", "PLN", "CAD", "GBP"]
    var viewMode: ViewMode = .normal
    
    
    init() {
        self.baseCurrency = Dynamic(Currency(code: "EUR", rate: 1.0))
        self.currencyRates = Dynamic(nil)
        self.navTitle = Dynamic("Add Currency")
        getCurrencies()
    }
    
    /// Get currencies from API.
    private func getCurrencies() {
        APICurrenciesRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    self.currencies = successResponse
                    self.updateViewData()
            },
                onFailure: { (errorResponse, error) in
                    print("Error occurred during download process")
                    if errorResponse != nil {
                        print("Error: \(errorResponse!.error.info)")
                    }
            })
    }
    
    /// Sets currencyRates data for active viewMode and updates View with current Data.
    private func updateViewData() {
        if let currencies = currencies {
            switch viewMode {
            case .normal:
                currencyRates.value = CurrencyManager.getMarkedCurrencies(from: currencies, with: markedCurrenciesList)
            case .addCurrency:
                currencyRates.value = CurrencyManager.getFullList(currencies: currencies)
            }
        }
    }
    
    // MARK: - Protocol Functions
    
    /// Switch viewMode and displayed data.
    func navButtonClickedAction() {
        switch viewMode {
        case .normal:
            viewMode = .addCurrency
            navTitle.value = NSLocalizedString("Main: Save", comment: "")
        case .addCurrency:
            viewMode = .normal
            navTitle.value = NSLocalizedString("Main: Add Currency", comment: "")
        }
        updateViewData()
    }
    
    /// Gets data for cell with given index.
    /// - parameter index: index of current cell
    /// - parameter amountText: text from amountField with number to convert
    /// - returns: currency of given index, converted rate, and Bool with infromation, if it is in markedCurrenciesList
    func getCellDataForCurrency(at index: Int, amountText: String?) -> (currency: Currency, rate: Double, isMarked: Bool) {
        if let currencyRates = currencyRates.value {
            let currency = currencyRates[index]
            let rate = CurrencyManager.getCurrencyRate(currencyRate: currency.rate, baseCurrencyRate: baseCurrency.value.rate, amount: getAmount(amountText))
            let isMarked = isCurrencyMarked(at: index)
            return (currency, rate, isMarked)
        } else {
            fatalError("There is no currencyRates")
        }
    }
    
    /// Action function for tapping on cell. It choose action depends on viewMode.
    func tapOnCellAction(at rowIndex: Int) {
        switch viewMode {
        case .normal:
            normalSelectRow(rowIndex: rowIndex)
        case .addCurrency:
            addCurrencySelectRow(rowIndex: rowIndex)
        }
    }
    
    /// MARK: - Helper Functions
    
    /// Action for tapping on cell, when viewMode is .normal. It's changing the baseCurrency.
    fileprivate func normalSelectRow(rowIndex: Int) {
        if let currencyRates = currencyRates.value {
            markedCurrenciesList.append(baseCurrency.value.code)
            baseCurrency.value = currencyRates[rowIndex]
            if let index = markedCurrenciesList.firstIndex(of: baseCurrency.value.code) {
                markedCurrenciesList.remove(at: index)
            }
            updateViewData()
        }
    }
    
    /// Action for tapping on cell, when viewMode is .addCurrency. It's adding currency to currencyRates
    fileprivate func addCurrencySelectRow(rowIndex: Int) {
        if let currencyRates = currencyRates.value {
            if markedCurrenciesList.contains(currencyRates[rowIndex].code) {
                if let index = markedCurrenciesList.firstIndex(of: currencyRates[rowIndex].code) {
                    markedCurrenciesList.remove(at: index)
                }
            } else {
                markedCurrenciesList.append(currencyRates[rowIndex].code)
            }
            updateViewData()
        }
    }
    
    /// Gets Double amount from string.
    fileprivate func getAmount(_ amountText: String?) -> Double {
        if let amountText = amountText, amountText != "" {
            return Double(amountText) ?? 1.0
        } else {
            return 1.0
        }
    }
    
    /// Check if currency with given index is on markedCurrenciesList
    fileprivate func isCurrencyMarked(at index: Int) -> Bool {
        if let currencyRates = currencyRates.value {
            return markedCurrenciesList.contains(currencyRates[index].code)
        } else {
            fatalError("There is no currencyRates")
        }
    }
    
}
