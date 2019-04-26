//
//  CurrencyCell.swift
//  CurrencyChanger
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {

    private let currencyCodeLabel = UILabel()
    private let currencyRateLabel = UILabel()
    
    var rate: Double = 0.0
    var currency : Currency? {
        didSet {
            if let currency = currency {
                currencyCodeLabel.text = currency.code
                currencyRateLabel.text = String(describing: (rate).rounded(toPlaces: 2))
            }
        }
    }
    
    // MARK: - Lifecycle methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(currencyCodeLabel)
        addSubview(currencyRateLabel)
        currencyCodeLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        currencyRateLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setups
    
    func setup(currency: Currency, rate: Double, isMarked: Bool) {
        setupCurrencyCodeLabel()
        setupCurrencyRateLabel()
        self.rate = rate
        self.currency = currency
        if isMarked {
            currencyCodeLabel.textColor = .black
            currencyRateLabel.textColor = .black
        } else {
            currencyCodeLabel.textColor = .gray
            currencyRateLabel.textColor = .gray
        }
    }
    
    private func setupCurrencyCodeLabel() {
        currencyCodeLabel.textColor = .gray
        currencyCodeLabel.font = UIFont.systemFont(ofSize: 16)
        currencyCodeLabel.textAlignment = .left
        currencyCodeLabel.numberOfLines = 0
    }
    
    private func setupCurrencyRateLabel() {
        currencyRateLabel.textColor = .gray
        currencyRateLabel.font = UIFont.systemFont(ofSize: 16)
        currencyRateLabel.textAlignment = .right
        currencyRateLabel.numberOfLines = 0
    }
}
