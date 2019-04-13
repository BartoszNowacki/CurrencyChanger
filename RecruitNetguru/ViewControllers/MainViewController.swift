//
//  MainViewController.swift
//  RecruitNetguru
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit

enum ViewMode {
    case normal
    case addCurrency
}

final class MainViewController: UIViewController {
    
    let mainStackView = UIStackView()
    let ratesStackView = UIStackView()
    let tableView = UITableView()
    let baseCurrencyLabel = UILabel()
    let amountField = UITextField()
    let navButton = UIBarButtonItem(title: "Add Currency", style: .plain, target: nil, action: #selector(navButtonClicked))
    
    var currencies: Currencies?
    var baseCurrency = Currency(code: "EUR", rate: 1.0)
    var markedCurrenciesList = ["USD", "PLN", "CAD", "GBP"]
    var currencyRates: [Currency]?
    var viewMode: ViewMode = .normal
    let cellID = "CurrencyCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getCurrencies()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .all
    }
    
    // MARK: - Setups View Components
    
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
        navItem.rightBarButtonItem = navButton
        navBar.setItems([navItem], animated: false)
    }
    
    private func setupBaseView()  {
        let baseStackView = UIStackView()
        baseStackView.axis = .horizontal
        baseStackView.addArrangedSubview(baseCurrencyLabel)
        baseStackView.addArrangedSubview(amountField)
        baseCurrencyLabel.text = "No currency"
        setupAmountField()
        baseStackView.heightAnchor.constraint(equalToConstant: self.view.frame.height/4).isActive = true
        ratesStackView.addArrangedSubview(baseStackView)
    }
    
    private func setupAmountField() {
        amountField.placeholder = "enter amount"
        amountField.keyboardType = .decimalPad
        amountField.textAlignment = .right
        amountField.delegate = self
        amountField.addDoneButtonToKeyboard(myAction:  #selector(self.amountField.resignFirstResponder))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: cellID)
        ratesStackView.addArrangedSubview(tableView)
    }
    
    // MARK: - Other Functions
    
    /// Sets currencyRates data for active viewMode and updates View with current Data
    private func updateViewAndBaseData() {
        if currencies != nil {
            switch viewMode {
            case .normal:
                currencyRates = CurrencyManager.getMarkedCurrencies(from: currencies!, with: markedCurrenciesList)
            case .addCurrency:
                currencyRates = CurrencyManager.getFullList(currencies: self.currencies!)
            }
        }
        baseCurrencyLabel.text = baseCurrency.code
        tableView.reloadData()
    }
    
    /// Get currencies from API.
    private func getCurrencies() {
        APICurrenciesRequest()
            .dispatch(
                onSuccess: { (successResponse) in
                    self.currencies = successResponse
                    self.updateViewAndBaseData()
            },
                onFailure: { (errorResponse, error) in
                    print("Error occurred during download process")
                    if errorResponse != nil {
                        print("Error: \(errorResponse!.error.info)")
                    }
            })
    }
    
    /// Takes value from amountField and checks if it's not empty or nil (otherwiese returns 1.0)
    /// - returns: Double
    private func getAmount() -> Double {
        if amountField.text != nil && amountField.text != "" {
            let amount = amountField.text!
            return Double(amount) ?? 1.0
        } else {
            return 1.0
        }
    }
    
    /// Navigation button action, which change current viewMode state.
    @objc func navButtonClicked() {
        switch viewMode {
        case .normal:
            viewMode = .addCurrency
            navButton.title = "Save"
        case .addCurrency:
            viewMode = .normal
            navButton.title = "Add Currency"
        }
        updateViewAndBaseData()
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
            let isOnMarkedList = markedCurrenciesList.contains(currencyRates![indexPath.row].code)
            let rate = CurrencyManager.getCurrencyRate(currencyRate: currencyRates![indexPath.row].rate, baseCurrencyRate: baseCurrency.rate, amount: getAmount())
            cell.setup(currency: currencyRates![indexPath.row], rate: rate, isMarked: isOnMarkedList)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewMode {
        case .normal:
           normalSelectRow(rowIndex: indexPath.row)
        case .addCurrency:
            addCurrencySelectRow(rowIndex: indexPath.row)
        }
    }
    
    private func normalSelectRow(rowIndex: Int) {
        markedCurrenciesList.append(baseCurrency.code)
        baseCurrency = currencyRates![rowIndex]
        if let index = markedCurrenciesList.firstIndex(of: baseCurrency.code) {
            markedCurrenciesList.remove(at: index)
        }
        updateViewAndBaseData()
    }
    
    private func addCurrencySelectRow(rowIndex: Int) {
        if markedCurrenciesList.contains(currencyRates![rowIndex].code) {
            if let index = markedCurrenciesList.firstIndex(of: currencyRates![rowIndex].code) {
                markedCurrenciesList.remove(at: index)
            }
        } else {
            markedCurrenciesList.append(currencyRates![rowIndex].code)
        }
        updateViewAndBaseData()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.reloadData()
    }
}
