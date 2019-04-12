//
//  Currency.swift
//  RecruitNetguru
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import Foundation

struct Currencies: Codable {
    
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    var rates: [String: Double]
}
