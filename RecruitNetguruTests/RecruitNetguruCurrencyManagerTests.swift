//
//  RecruitNetguruTests.swift
//  RecruitNetguruTests
//
//  Created by Bartosz Nowacki on 12/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import XCTest
@testable import RecruitNetguru

class RecruitNetguruCurrencyManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCurrencyRateConvertion() {
        // 1. given
        let currencyRate = 2.5
        let baseCurrencyRate = 5.0
        let amount = 3.0
        // 2. when
        let score =  CurrencyManager.getCurrencyRate(currencyRate: currencyRate, baseCurrencyRate: baseCurrencyRate, amount: amount)
        
        // 3. then
        XCTAssertEqual(score, 1.5, "Currency convertion is wrong")
    }
    
    func testGetFullList() {
        // 1. given
        let currencies = Currencies(success: true, timestamp: 1, base: "USD", date: "12-12-2012", rates: ["PLN":1.0, "USD":2.5, "GBP":2.2])
        // 2. when
        let list =  CurrencyManager.getFullList(currencies: currencies)
        // 3. then
        XCTAssertEqual(list.count, currencies.rates.count, "Did not returned equal number of currencies")
    }
    
    func testGetMarkedCurrencies() {
        // 1. given
        let currencies = Currencies(success: true, timestamp: 1, base: "USD", date: "12-12-2012", rates: ["PLN":1.0, "USD":2.5, "GBP":2.2])
        let markedList = ["PLN", "GBP", "RUB"]
        // 2. when
        let list =  CurrencyManager.getMarkedCurrencies(from: currencies, with: markedList)
        // 3. then
        XCTAssertEqual(list.count, 2, "Did not returned correct number of currencies")
    }
    
    func testIsMarked() {
        // 1. given
        let currency = Currency(code: "PLN", rate: 2.5)
        let markedList = ["PLN", "GBP", "RUB"]
        // 2. when
        let isMarked =  CurrencyManager.checkIfCurrencyIsMarked(currency: currency, markedList: markedList)
        // 3. then
        XCTAssertTrue(isMarked, "Function did not set isMarked properly")
    }

}
