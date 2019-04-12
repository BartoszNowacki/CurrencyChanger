//
//  MainViewController.swift
//  RecruitNetguru
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    let mainStackView = UIStackView()
    let ratesStackView = UIStackView()
    let tableView = UITableView()
    let baseCurrencyLabel = UILabel()
    let amountField = UITextField()
    
    var currencies: Currencies?
    var currencyRates: [Currency]?
    let cellID = "CurrencyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        currencies = Currencies(success: true, timestamp: 1, base: "EUR", date: "Date", rates: ["PLN": 1.24, "GBD": 1.33])
        currencyRates = convertCurrencyData()
        updateView()
        tableView.reloadData()
    }
    
    private func setupView() {
        setupMainStack()
        setupNavBar()
        setupRatesStack()
        setupBaseView()
        setupTableView()
    }
    
    private func setupMainStack() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: mainStackView.bottomAnchor, multiplier: 1.0)
            ])
    }
    
    private func setupRatesStack() {
        ratesStackView.translatesAutoresizingMaskIntoConstraints = false
        ratesStackView.axis = .vertical
        mainStackView.addArrangedSubview(ratesStackView)
        NSLayoutConstraint.activate([
            ratesStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            ratesStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
            ])
    }

    
    private func setupNavBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        mainStackView.addArrangedSubview(navBar)
        
        let navItem = UINavigationItem(title: "Currency Converter")
        let buttonItem = UIBarButtonItem(title: "Options", style: .plain, target: nil, action: #selector(navButtonClicked))
        navItem.rightBarButtonItem = buttonItem
        
        navBar.setItems([navItem], animated: false)
    }
    
    private func setupBaseView()  {
        let baseStackView = UIStackView()
        baseStackView.axis = .horizontal
        baseStackView.addArrangedSubview(baseCurrencyLabel)
        baseStackView.addArrangedSubview(amountField)
        baseCurrencyLabel.text = "No currency"
        amountField.placeholder = "enter amount"
        amountField.keyboardType = .decimalPad
        baseStackView.heightAnchor.constraint(equalToConstant: self.view.frame.height/4).isActive = true
        ratesStackView.addArrangedSubview(baseStackView)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellID)
        ratesStackView.addArrangedSubview(tableView)
    }
    
    private func updateView() {
        baseCurrencyLabel.text = currencies?.base
        tableView.reloadData()
    }
    
    private func convertCurrencyData() -> [Currency] {
        var cRates = [Currency]()
        for code in Array(currencies!.rates.keys) {
            let rate = currencies!.rates[code]!
            cRates.append(Currency(code: code, rate: rate))
        }
        print("tbdc it is working!!!! \(cRates)")
        return cRates
    }
    
    @objc func navButtonClicked() {
        print("color clicked")
    }
    

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currencyRates != nil {
            return currencyRates!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CurrencyCell
        if currencyRates != nil {
            cell.currency = currencyRates![indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.reloadData()
    }
}
