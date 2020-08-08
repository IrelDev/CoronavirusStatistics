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
    let searchController = UISearchController(searchResultsController: nil)
    
    var countries: [String] = []
    var countriesSearchResult: [String] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondarySystemGroupedBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        return activityIndicator
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        dataFetcher.fetchDataFromURl(url: API.countryListURL!) { [self] (response: CountriesWrappedResponse?) in
            if let response = response {
                DispatchQueue.main.sync {
                    countries = response.response
                    
                    UIView.transition(with: tableView,
                                      duration: 1,
                                      options: .transitionCrossDissolve,
                                      animations: { tableView.reloadData() })
                    activityIndicator.stopAnimating()
                }
                return
            }
        }
    }
    func setupViews() {
        setupNavigationController()
        setupTableView()
        setupSearchController()
        setupActivityIndicatorView()
    }
    func setupNavigationController() {
        self.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .secondarySystemGroupedBackground
    }
    func setupTableView() {
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
    func setupActivityIndicatorView() {
        tableView.backgroundView = activityIndicator
        if countries.count == 0 { activityIndicator.startAnimating() }
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text?.count != 0 {
            return countriesSearchResult.count
        }
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country: String
        if searchController.isActive && searchController.searchBar.text?.count != 0 {
            country = countriesSearchResult[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        cell.textLabel?.text = country
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        cell.backgroundColor = .clear
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country: String
        if searchController.isActive && searchController.searchBar.text?.count != 0 {
            country = countriesSearchResult[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        let viewController = SearchDetailViewController()
        viewController.country = country
        navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - UISearchController
extension SearchViewController: UISearchResultsUpdating {
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search countries"
        
        searchController.searchBar.tintColor = .label
        searchController.searchBar.barTintColor = .secondarySystemGroupedBackground
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterResults(for: searchController.searchBar.text ?? "")
    }
    func filterResults(for searchText: String) {
        countriesSearchResult = countries.filter {
            $0.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
