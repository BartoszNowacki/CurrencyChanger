//
//  MainViewModelProtocol.swift
//  RecruitNetguru
//
//  Created by Bartosz Nowacki on 14/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

protocol MainViewModelProtocol {
    var currencyRates: Dynamic<[Currency]?> { get }
    var baseCurrency: Dynamic<Currency> { get }
    var navTitle: Dynamic<String> { get }
    func tapOnCellAction(at rowIndex: Int)
    func navButtonClickedAction()
    func getCellDataForCurrency(at index: Int, amountText: String?) -> (currency: Currency, rate: Double, isMarked: Bool)
}
