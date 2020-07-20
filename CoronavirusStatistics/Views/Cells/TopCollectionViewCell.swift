//
//  TopCollectionViewCell.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    private var country = "Loading.."
    private var title = ""
    private var cases = 0
    var today: String = "loading"
    var color: UIColor = .label
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let countryLabel: UILabel = {
        let countryLabel = UILabel()
        countryLabel.font = countryLabel.font.withSize(30)
        
        return countryLabel
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = titleLabel.font.withSize(30)
        
        return titleLabel
    }()
    private let casesLabel: UILabel = {
        let casesLabel = UILabel()
        casesLabel.font = casesLabel.font.withSize(25)
        
        return casesLabel
    }()
    private let todayNewCasesLabel: UILabel = {
        let todayNewCasesLabel = UILabel()
        todayNewCasesLabel.font = todayNewCasesLabel.font.withSize(15)
        
        return todayNewCasesLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tertiarySystemGroupedBackground
        layer.cornerRadius = 25
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initDataForWorldCell(data: TopStatistics) {
        country = data.country
        title = data.title
        color = data.color
        cases = data.cases
        today = data.casesToday
        
        titleLabel.text = title
        countryLabel.text = country
        casesLabel.text = "\(cases)"
        casesLabel.textColor = color
        
        let todayNewCasesMutableString = NSMutableAttributedString(string: "\(today) today")
        todayNewCasesMutableString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 1, length: today.count))
        todayNewCasesLabel.attributedText = todayNewCasesMutableString
    }
    private func setupViews() {
        countryLabel.text = country
        addSubview(countryLabel)
        
        titleLabel.text = title
        addSubview(titleLabel)
        
        casesLabel.text = "\(cases)"
        casesLabel.textColor = color
        addSubview(casesLabel)
        
        let todayNewCasesString = "\(today)"
        let todayNewCasesMutableString = NSMutableAttributedString(string: "+ \(todayNewCasesString) today")
        
        todayNewCasesMutableString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 2, length: todayNewCasesString.count))
        todayNewCasesLabel.attributedText = todayNewCasesMutableString
        
        let casesStackView = UIStackView()
        casesStackView.axis = .vertical
        casesStackView.alignment = .trailing
        casesStackView.distribution = .fill
        
        casesStackView.addArrangedSubview(titleLabel)
        casesStackView.addArrangedSubview(casesLabel)
        casesStackView.addArrangedSubview(todayNewCasesLabel)
        
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(casesStackView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            stackView.bottomAnchor.constraint(equalTo: todayNewCasesLabel.bottomAnchor)
        ])
    }
}

