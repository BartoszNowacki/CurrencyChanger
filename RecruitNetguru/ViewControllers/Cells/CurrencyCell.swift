//
//  CurrencyCell.swift
//  RecruitNetguru
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {

    var rate: Double!
    var currency : Currency! {
        didSet {
            currencyCodeLabel.text = currency.code
            currencyRateLabel.text = String(describing: (rate).rounded(toPlaces: 2))
        }
    }
    
    private let currencyCodeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private let currencyRateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
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
}
