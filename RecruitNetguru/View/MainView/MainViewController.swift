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
    
    let cellID = "CurrencyCell"
    
    let viewModel: MainViewModelProtocol
    
    init(viewModel: MainViewModelProtocol = MainViewViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = MainViewViewModel()
        super.init(coder: aDecoder)
        self.bindViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .all
    }
    
    fileprivate func bindViewModel() {
        viewModel.navTitle.bindAndFire {
            [unowned self] in
            self.navButton.title = $0
            print("tbdc navTitle invoked")
        }
        viewModel.baseCurrency.bindAndFire {
            [unowned self] in
            self.baseCurrencyLabel.text = $0.code
            print("tbdc baseCurrency invoked")
        }
        viewModel.currencyRates.bindAndFire {
            [unowned self] in
            if $0 != nil {
                self.tableView.reloadData()
                print("tbdc currencyRates invoked")
            }
        }
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
    
    /// Takes value from amountField and checks if it's not empty or nil (otherwiese returns 1.0)
    /// - returns: Double
    private func getAmount() -> Double {
        if let amount = amountField.text, amount != "" {
            return Double(amount) ?? 1.0
        } else {
            return 1.0
        }
    }
    
    /// Navigation button action, which change current viewMode state.
    @objc func navButtonClicked() {
        viewModel.navButtonClickedAction()
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currencyRates = viewModel.currencyRates.value {
            print("count is \(currencyRates.count)")
            return currencyRates.count
        } else {
            print("count is else 0")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CurrencyCell
        let cellData = viewModel.getCellDataForCurrency(at: indexPath.row, amountText: amountField.text)
        cell.setup(currency: cellData.currency, rate: cellData.rate, isMarked: cellData.isMarked)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tapOnCell(at: indexPath.row)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.reloadData()
    }
}
