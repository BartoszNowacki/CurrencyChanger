//
//  Currency.swift
//  CurrencyChanger
//
//  Created by Bartosz Nowacki on 11/04/2019.
//  Copyright © 2019 Appunite. All rights reserved.
//

import Foundation

struct Currency {
    let code: String
    let flag: String
    let rate: Double
}

extension Currency: Comparable {
    public static func <(lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code<rhs.code
    }
}
