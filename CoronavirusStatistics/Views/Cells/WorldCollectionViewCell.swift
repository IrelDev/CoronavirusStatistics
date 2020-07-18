//
//  WorldCollectionViewCell.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

class WorldCollectionViewCell: UICollectionViewCell {
    var title: String = "Loading..."
    var cases: Int = 0
    var today: String = "loading"
    var color: UIColor = .label
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = titleLabel.font.withSize(27)
        return titleLabel
    }()
    private let casesLabel: UILabel = {
        let casesLabel = UILabel()
        casesLabel.font = casesLabel.font.withSize(23)
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
    
    func initDataForWorldCell(data: Response, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            title = "Cases"
            color = .label
            cases = data.cases.total
            today = data.cases.new ?? " no information"
        case 1:
            title = "Deaths"
            color = .red
            cases = data.deaths.total
            today = data.deaths.new ?? " no information"
        case 2:
            title = "Recovered"
            color = .green
            cases = data.cases.recovered
            today = " no information" //the api does not provide daily updates of recovered patients yet
        default:
            fatalError()
        }
        titleLabel.text = title
        casesLabel.text = "\(cases)"
        casesLabel.textColor = color
        
        let todayNewCasesMutableString = NSMutableAttributedString(string: "\(today) today")
        todayNewCasesMutableString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 1, length: today.count))
        todayNewCasesLabel.attributedText = todayNewCasesMutableString
    }
    func setupViews() {
        titleLabel.text = title
        addSubview(titleLabel)
        
        casesLabel.text = "\(cases)"
        casesLabel.textColor = color
        addSubview(casesLabel)
        
        let todayNewCasesMutableString = NSMutableAttributedString(string: "\(today) today")
        
        todayNewCasesMutableString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 1, length: today.count))
        todayNewCasesLabel.attributedText = todayNewCasesMutableString
        
        addSubview(todayNewCasesLabel)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(casesLabel)
        stackView.addArrangedSubview(todayNewCasesLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            stackView.bottomAnchor.constraint(equalTo: todayNewCasesLabel.bottomAnchor)
        ])
    }
}

