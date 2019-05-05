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
        let cRates = currencies.rates.map { Currency(code: $0.key, flag: getCurrencyFlag(for: $0.key), rate: $0.value) }
        return cRates.sorted(by: <)
    }
    
    /// Function which is returning Array of Currency Models, only from markedList.
    /// - parameter Currencies: Main model from API
    /// - parameter markedList: String array of currency codes, which is base for returning element
    /// - returns: [Currency] - List of marked Currency
    static func getMarkedCurrencies(from currencies: Currencies, with markedList: [String]) -> [Currency] {
        let baseList = getFullList(currencies: currencies)
        let currencyList = baseList.filter { markedList.contains($0.code) }
        return currencyList
    }
    
    /// Function which is returning Array of Currency Models for given searched code.
    /// - parameter Currencies: Main model from API
    /// - parameter searchedText: String which contains part or full code of currency.
    /// - returns: [Currency] - List of searched Currencies
    static func getSearchedCurrencies(from currencies: Currencies, from searchedText: String) -> [Currency] {
        let baseList = getFullList(currencies: currencies)
        let currencyList = baseList.filter { $0.code.hasPrefix(searchedText.uppercased())}
        return currencyList
    }
    
    /// Function which converts currency code into currency code with unicode for region flag
    /// - parameter currencyCode: String with currency code to be converted
    /// - returns: String - currency code with unicode for region flag or empty space, if currency is excluded
    static func getCurrencyFlag(for currencyCode: String) -> String {
        let excludedCurrencies = ["XPF", "XOF", "XDR", "XCD", "XAU" ,"XAG" , "XAF", "ANG"]
        let country = currencyCode.dropLast(1)
        let base : UInt32 = 127397
        if !excludedCurrencies.contains(currencyCode) {
            let flag = country.unicodeScalars.reduce("") { (result, code) in
                result + String(UnicodeScalar(base + code.value)!)
            }
            return flag
        }
        return ""
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
