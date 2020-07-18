//
//  SearchViewController.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    let dataFetcher = DataFetcher()
    var countries: [String] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondarySystemGroupedBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
        
        dataFetcher.fetchDataFromURl(url: API.countryListURL!) { (response: CountriesWrappedResponse?) in
            if let response = response {
                DispatchQueue.main.sync {
                    self.countries = response.response
                    
                    UIView.transition(with: self.tableView,
                                      duration: 1,
                                      options: .transitionCrossDissolve,
                                      animations: { self.tableView.reloadData() })
                }
                return
            }
        }
    }
    func setupNavigationController() {
        self.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupTableView() {
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = countries[indexPath.row]
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        cell.backgroundColor = .clear
        
        return cell
    }
}
