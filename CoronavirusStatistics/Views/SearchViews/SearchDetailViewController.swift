//
//  SearchDetailViewController.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    var country: String!
    
    let dataFetcher = DataFetcher()
    var countryData: Response?
    
    override func viewDidLoad() {
        view.backgroundColor = .secondarySystemGroupedBackground
        
        setupNavigationController()
        dataFetcher.fetchDataFromURl(url: API.createLinkForCountry(country: country)!) { (response: Response?) in
            if let response = response {
                DispatchQueue.main.sync {
                    self.countryData = response
                }
                return
            }
        }
    }
    func setupNavigationController() {
        navigationController?.navigationBar.backgroundColor = .secondarySystemGroupedBackground
        title = country
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
