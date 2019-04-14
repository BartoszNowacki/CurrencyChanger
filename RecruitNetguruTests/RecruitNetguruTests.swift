//
//  RecruitNetguruTests.swift
//  RecruitNetguruTests
//
//  Created by Bartosz Nowacki on 12/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import XCTest
@testable import RecruitNetguru

class RecruitNetguruTests: XCTestCase {
    var currencyManagerTest: CurrencyManager!
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testScoreIsComputedWhenGuessGTTarget() {
        // 1. given
        let currencyRate = 2.5
        let baseCurrencyRate = 5.0
        let amount = 3.0
        // 2. when
        let score =  CurrencyManager.getCurrencyRate(currencyRate: currencyRate, baseCurrencyRate: baseCurrencyRate, amount: amount)
        
        // 3. then
        XCTAssertEqual(score, 1.5, "Currency convertion is wrong")
    }

}
