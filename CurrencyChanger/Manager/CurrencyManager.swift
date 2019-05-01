//
//  CurrencyConverter.swift
//  CurrencyChanger
//
//  Created by Bartosz Nowacki on 13/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

class CurrencyManager {
    
    /// Converts Currencies model to array of Currency Models.
    /// - parameter Currencies: Main model from API
    /// - returns: [Currency] Full list of sorted Currency models
    static func getFullList(currencies: Currencies) -> [Currency] {
        var cRates = [Currency]()
        for code in Array(currencies.rates.keys).sorted() {
            let rate = currencies.rates[code]!
            cRates.append(Currency(code: code, rate: rate))
        }
        return cRates
    }
    
    /// Function which is returning Array of Currency Models, only from markedList.
    /// - parameter Currencies: Main model from API
    /// - parameter markedList: String array of currency codes, which is base for returning element
    /// - returns: [Currency] - List of marked Currency
    static func getMarkedCurrencies(from currencies: Currencies, with markedList: [String]) -> [Currency] {
        let baseList = getFullList(currencies: currencies)
        var currencyList = [Currency]()
        for currency in baseList {
            if markedList.contains(currency.code) {
                currencyList.append(currency)
            }
        }
        return currencyList
    }
    
    
    /// Function check if given currency is marked.
    /// - parameter currency: Currency to be checked
    /// - parameter markedList: String array of marked currency codes
    /// - returns: Bool - is Currency marked
    static func checkIfCurrencyIsMarked(currency: Currency, markedList: [String]) -> Bool {
        return markedList.contains(currency.code)
    }
    
    
    /// Function is converting currency rate for given currency
    /// - parameter currencyRate: currency base rate of given Currency
    /// - parameter baseCurrencyRate: currency base rate of Base Currency
    /// - parameter amount: amount of currency to be converted
    /// - returns: Double - Converted currency
    static func getCurrencyRate(currencyRate: Double, baseCurrencyRate: Double, amount: Double) -> Double {
        return currencyRate / baseCurrencyRate * amount
    }
}
