//
//  MainViewViewModel.swift
//  RecruitNetguru
//
//  Created by Bartosz Nowacki on 14/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

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
    }
    
    func normalSelectRow(rowIndex: Int) {
        markedCurrenciesList.append(baseCurrency.code)
        baseCurrency = currencyRates![rowIndex]
        if let index = markedCurrenciesList.firstIndex(of: baseCurrency.code) {
            markedCurrenciesList.remove(at: index)
        }
        updateViewAndBaseData()
    }
    
    func addCurrencySelectRow(rowIndex: Int) {
        if let currencyRates = currencyRates {
            if markedCurrenciesList.contains(currencyRates[rowIndex].code) {
                if let index = markedCurrenciesList.firstIndex(of: currencyRates[rowIndex].code) {
                    markedCurrenciesList.remove(at: index)
                }
            } else {
                markedCurrenciesList.append(currencyRates[rowIndex].code)
            }
            updateViewAndBaseData()
        }
    }
    
}
