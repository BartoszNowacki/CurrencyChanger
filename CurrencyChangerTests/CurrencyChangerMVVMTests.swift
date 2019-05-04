//
//  CurrencyChangerMVVMTests.swift
//  CurrencyChangerTests
//
//  Created by Bartosz Nowacki on 14/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import XCTest
@testable import CurrencyChanger

class CurrencyChangerMVVMTests: XCTestCase {

    var mainVVMTest: MainViewViewModel!
    
    override func setUp() {
         super.setUp()
        mainVVMTest = MainViewViewModel()
    }

    override func tearDown() {
        mainVVMTest = nil
        super.tearDown()
    }
    
    func testTapOnCellNormal() {
        // 1. given
        let markedList = ["PLN", "GBP", "RUB"]
        let currencyRates = [Currency(code: "PLN", flag: "🇵🇱", rate: 1.0), Currency(code: "USD", flag: "🇺🇸", rate: 2.5), Currency(code: "GBP", flag: "🇬🇧", rate: 2.2)]
         mainVVMTest.currencies = Currencies(success: true, timestamp: 1, base: "EUR", date: "12-12-2012", rates: ["PLN":1.0, "USD":2.5, "GBP":2.2])
        mainVVMTest.viewMode.value = .normal
        mainVVMTest.currencyRates.value = currencyRates
        mainVVMTest.markedCurrenciesList = markedList
        let baseCode = mainVVMTest.baseCurrency.value.code
        // 2. when
        let index = 1
        mainVVMTest.tapOnCellAction(at: index)
        // 3. then
            XCTAssertEqual(mainVVMTest.baseCurrency.value.code, currencyRates[index].code, "Did not change baseCurrency correctly")
            XCTAssertTrue(mainVVMTest.markedCurrenciesList.contains(baseCode), "Did not found old baseCurrency in markedList")
            XCTAssertFalse(mainVVMTest.markedCurrenciesList.contains(currencyRates[index].code), "New Base Currency is still in marked list")
    }
    
    func testTapOnCellAddCurrency() {
        // 1. given
        let markedList = ["PLN"]
        mainVVMTest.currencies = Currencies(success: true, timestamp: 1, base: "USD", date: "12-12-2012", rates: ["PLN":1.0, "USD":2.5, "GBP":2.2])
        mainVVMTest.viewMode.value = .addCurrency
        mainVVMTest.markedCurrenciesList = markedList
        mainVVMTest.currencyRates.value = [Currency(code: "PLN", flag: "🇵🇱", rate: 1.0), Currency(code: "USD", flag: "🇺🇸", rate: 2.5), Currency(code: "GBP", flag: "🇬🇧", rate: 2.2)]
        // 2. when
        mainVVMTest.tapOnCellAction(at: 1)
        // 3. then
        XCTAssertEqual(mainVVMTest.markedCurrenciesList.count, markedList.count + 1, "Test fails, cause of markedCurrenciesList wasn't append")
    }
    
    func testGetCellData() {
        // 1. given
        let amountText = "20"
        let index = 2
        let currencyRates = [Currency(code: "PLN", flag: "🇵🇱", rate: 1.3), Currency(code: "USD", flag: "🇺🇸", rate: 2.5), Currency(code: "GBP", flag: "🇬🇧", rate: 2.2)]
        let markedList = ["PLN", "GBP"]
        mainVVMTest.markedCurrenciesList = markedList
        mainVVMTest.currencyRates.value = currencyRates
        // 2. when
        let data = mainVVMTest.getCellDataForCurrency(at: index, amountText: amountText)
        // 3. then
        XCTAssertEqual(data.currency.code, currencyRates[index].code, "Function did not return correct currency")
        XCTAssertEqual(data.rate, 44, "Rate is not correct")
        XCTAssertEqual(data.isMarked, markedList.contains(currencyRates[index].code), "Did not marked currency correctly")
    }
    
    func testNavButtonClickedAction() {
        // 1. given
        mainVVMTest.currencies = Currencies(success: true, timestamp: 1, base: "USD", date: "12-12-2012", rates: ["PLN":1.0, "USD":2.5, "GBP":2.2])
        let viewMode: ViewMode = .normal
        mainVVMTest.viewMode.value = viewMode
        // 2. when
        mainVVMTest.navButtonClickedAction()
        // 3. then
        XCTAssertNotEqual(mainVVMTest.viewMode.value, viewMode, "viewMode did not changed")
        if let currencyRates = mainVVMTest.currencyRates.value, let currencies = mainVVMTest.currencies {
            XCTAssertEqual(currencyRates.count, currencies.rates.count, "Did not get full list of elements")
        } else {
            XCTFail("There is no currencyRates")
        }
    }
}
