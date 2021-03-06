//
//  MainViewController.swift
//  CurrencyChanger
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    let mainStackView = UIStackView()
    let ratesStackView = UIStackView()
    let tableView = UITableView()
    let baseFlagLabel = UILabel()
    let baseCurrencyLabel = UILabel()
    let amountField = UITextField()
    let searchBar = UISearchBar()
    var navButton = UIBarButtonItem()
    
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
    
    
    /// This functions bind data from viewModel. If change occurs, the view will respond and update itself.
    fileprivate func bindViewModel() {
        viewModel.viewMode.bindAndFire {
            [unowned self] in
            self.setupNavButton(isAddingMode: $0 == ViewMode.addCurrency)
            }
        viewModel.baseCurrency.bindAndFire {
            [unowned self] in
            self.baseCurrencyLabel.text = $0.flag + $0.code
        }
        viewModel.currencyRates.bindAndFire {
            [unowned self] in
            if $0 != nil {
                self.tableView.reloadData()
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
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Search Currency"
        setupNavButton()
    }
    
    private func setupNavButton(isAddingMode: Bool = false) {
        let navButton = UIBarButtonItem(barButtonSystemItem: isAddingMode ? .save : .add, target: self, action: #selector(navButtonClicked))
        self.navigationItem.rightBarButtonItem = navButton
        self.navigationItem.titleView = isAddingMode ? searchBar : nil
    }
    
    private func setupBaseView()  {
        let baseStackView = UIStackView()
        baseStackView.axis = .horizontal
        baseStackView.addArrangedSubview(baseCurrencyLabel)
        baseStackView.addArrangedSubview(amountField)
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
    
    // MARK: - Button Actions
    
    /// Navigation button action, which change current viewMode state.
    @objc func navButtonClicked() {
        searchBar.text?.removeAll()
        viewModel.navButtonClickedAction()
    }

}

// MARK: - Delegate section

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
        viewModel.tapOnCellAction(at: indexPath.row)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.reloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchDidChange(with: searchText)
    }
}
