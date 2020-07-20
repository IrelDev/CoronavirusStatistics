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
    
    var casesStackView: UIStackView = {
        let casesStackView = UIStackView()
        casesStackView.axis = .vertical
        casesStackView.distribution = .equalCentering
        
        casesStackView.translatesAutoresizingMaskIntoConstraints = false
        return casesStackView
    }()
    var casesLabel: UILabel = {
        let casesLabel = UILabel()
        casesLabel.text = "Cases"
        casesLabel.font = casesLabel.font.withSize(30)
        casesLabel.textAlignment = .center
        
        return casesLabel
    }()
    var casesNewLabel: UILabel = {
        let casesNewLabel = UILabel()
        casesNewLabel.text = "New: loading"
        casesNewLabel.font = casesNewLabel.font.withSize(20)
        return casesNewLabel
    }()
    var casesActiveLabel: UILabel = {
        let casesActiveLabel = UILabel()
        casesActiveLabel.text = "Active: loading"
        casesActiveLabel.font = casesActiveLabel.font.withSize(20)
        return casesActiveLabel
    }()
    var casesCriticalLabel: UILabel = {
        let casesCriticalLabel = UILabel()
        casesCriticalLabel.text = "Critical: loading"
        casesCriticalLabel.font = casesCriticalLabel.font.withSize(20)
        return casesCriticalLabel
    }()
    var casesRecoveredLabel: UILabel = {
        let casesRecoveredLabel = UILabel()
        casesRecoveredLabel.text = "Recovered: loading"
        casesRecoveredLabel.font = casesRecoveredLabel.font.withSize(20)
        return casesRecoveredLabel
    }()
    var casesTotalLabel: UILabel = {
        let casesTotalLabel = UILabel()
        casesTotalLabel.text = "Total: loading"
        casesTotalLabel.font = casesTotalLabel.font.withSize(20)
        return casesTotalLabel
    }()
    var deathsTestsStackView: UIStackView = {
        let deathsTestsStackView = UIStackView()
        deathsTestsStackView.axis = .horizontal
        deathsTestsStackView.translatesAutoresizingMaskIntoConstraints = false
        deathsTestsStackView.spacing = 35
        deathsTestsStackView.distribution = .fillEqually
        
        return deathsTestsStackView
    }()
    var deathsStackView: UIStackView = {
        let deathsStackView = UIStackView()
        deathsStackView.axis = .vertical
        deathsStackView.distribution = .equalCentering
        
        return deathsStackView
    }()
    var deathsLabel: UILabel = {
        let deathsLabel = UILabel()
        deathsLabel.text = "Deaths"
        deathsLabel.font = deathsLabel.font.withSize(25)
        deathsLabel.textAlignment = .center
        return deathsLabel
    }()
    var deathsNewLabel: UILabel = {
        let deathsNewLabel = UILabel()
        deathsNewLabel.text = "New: loading"
        deathsNewLabel.font = deathsNewLabel.font.withSize(20)
        return deathsNewLabel
    }()
    var deathsTotalLabel: UILabel = {
        let deathsTotalLabel = UILabel()
        deathsTotalLabel.text = "Total: loading"
        deathsTotalLabel.font = deathsTotalLabel.font.withSize(20)
        return deathsTotalLabel
    }()
    var testsStackView: UIStackView = {
        let testsStackView = UIStackView()
        testsStackView.axis = .vertical
        testsStackView.distribution = .equalCentering
        
        return testsStackView
    }()
    var testsLabel: UILabel = {
        let testsLabel = UILabel()
        testsLabel.text = "Tests"
        testsLabel.font = testsLabel.font.withSize(30)
        testsLabel.textAlignment = .center
        return testsLabel
    }()
    var testsTotalLabel: UILabel = {
        let testsTotalLabel = UILabel()
        testsTotalLabel.text = "Total: loading"
        testsTotalLabel.font = testsTotalLabel.font.withSize(20)
        return testsTotalLabel
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .secondarySystemGroupedBackground
        
        setupNavigationController()
        setupViews()
        
        dataFetcher.fetchDataFromURl(url: API.createLinkForCountry(country: country)!) { (response: WrappedResponse?) in
            if let response = response?.response.first {
                DispatchQueue.main.sync {
                    self.countryData = response
                    self.updateLabels()
                }
                return
            }
        }
    }
    func setupNavigationController() {
        navigationController?.navigationBar.backgroundColor = .clear
        title = country
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupViews() {
        view.addSubview(casesStackView)
        view.addSubview(casesLabel)
        view.addSubview(casesNewLabel)
        view.addSubview(casesActiveLabel)
        view.addSubview(casesCriticalLabel)
        view.addSubview(casesRecoveredLabel)
        view.addSubview(casesTotalLabel)
        
        casesStackView.addArrangedSubview(casesLabel)
        casesStackView.addArrangedSubview(casesNewLabel)
        casesStackView.addArrangedSubview(casesActiveLabel)
        casesStackView.addArrangedSubview(casesCriticalLabel)
        casesStackView.addArrangedSubview(casesRecoveredLabel)
        casesStackView.addArrangedSubview(casesTotalLabel)
        
        view.addSubview(deathsStackView)
        view.addSubview(deathsLabel)
        view.addSubview(deathsNewLabel)
        view.addSubview(deathsTotalLabel)
        
        deathsStackView.addArrangedSubview(deathsLabel)
        deathsStackView.addArrangedSubview(deathsNewLabel)
        deathsStackView.addArrangedSubview(deathsTotalLabel)
        
        view.addSubview(testsStackView)
        view.addSubview(testsLabel)
        view.addSubview(testsTotalLabel)
        
        testsStackView.addArrangedSubview(testsLabel)
        testsStackView.addArrangedSubview(testsTotalLabel)
        
        view.addSubview(deathsTestsStackView)
        
        deathsTestsStackView.addArrangedSubview(deathsStackView)
        deathsTestsStackView.addArrangedSubview(testsStackView)
        
        setupAutoLayout()
        
        setupStackViews()
    }
    func setupStackViews() {
        let casesBounds = CGRect(x: 0, y: 0, width: casesStackView.bounds.width + 25, height: casesStackView.bounds.height + 25)
        casesStackView.setBackgroundColor(with: .tertiarySystemGroupedBackground, withRect: casesBounds, withCornerRadius: 25)
        
        let deathsBounds = CGRect(x: 0, y: 0, width: deathsTestsStackView.bounds.width + 25, height: deathsTestsStackView.bounds.height + 25)
        deathsStackView.setBackgroundColor(with: .tertiarySystemGroupedBackground, withRect: deathsBounds, withCornerRadius: 25)
        
        let testsBounds = CGRect(x: 0, y: 0, width: testsStackView.bounds.width + 25, height: testsStackView.bounds.height + 25)
        testsStackView.setBackgroundColor(with: .tertiarySystemGroupedBackground, withRect: testsBounds, withCornerRadius: 25)
    }
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            casesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            casesStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 25),
            casesStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            casesStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        NSLayoutConstraint.activate([
            deathsTestsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deathsTestsStackView.topAnchor.constraint(equalTo: casesStackView.bottomAnchor, constant: 55),
            deathsTestsStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            deathsTestsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    func updateLabels()  {
        casesNewLabel.text = "New: \(countryData?.cases.new ?? "no info")"
        casesActiveLabel.text = "Active: \(countryData?.cases.active ?? 0)"
        casesCriticalLabel.text = "Critical: \(countryData?.cases.critical ?? 0)"
        casesRecoveredLabel.text = "Recovered: \(countryData?.cases.recovered ?? 0)"
        casesTotalLabel.text = "Total: \(countryData?.cases.total ?? 0)"
        
        deathsNewLabel.text = "New: \(countryData?.deaths.new ?? "no info")"
        deathsTotalLabel.text = "Total: \(countryData?.deaths.total ?? 0)"
        
        testsTotalLabel.text = "Total : \(countryData?.tests.total ?? 0)"
    }
}
