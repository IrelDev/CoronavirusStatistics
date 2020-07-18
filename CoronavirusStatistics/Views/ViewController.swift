//
//  ViewController.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let dataFetcher = DataFetcher()
    var data: [Response] = []
    var worldData: Response?
    
    var topCasesStatistics: [TopStatistics] = []
    var topDeathsStatistics: [TopStatistics] = []
    var topRecoveredStatistics: [TopStatistics] = []
    
    private let worldLabel: UILabel = {
        let worldLabel = UILabel()
        worldLabel.font = worldLabel.font.withSize(30)
        worldLabel.text = "World"
        worldLabel.textAlignment = .center
        
        return worldLabel
    }()
    private let worldCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let worldCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        worldCollectionView.translatesAutoresizingMaskIntoConstraints = false
        worldCollectionView.backgroundColor = .clear
        
        return worldCollectionView
    }()
    private let worldStackView: UIStackView = {
        let worldStackView = UIStackView()
        worldStackView.axis = .vertical
        worldStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return worldStackView
    }()
    private let topCasesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let topCasesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topCasesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topCasesCollectionView.backgroundColor = .clear
        
        return topCasesCollectionView
    }()
    private let topDeathsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let topDeathsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topDeathsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topDeathsCollectionView.backgroundColor = .clear
        
        return topDeathsCollectionView
    }()
    private let topRecoveredCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let topRecoveredCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topRecoveredCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topRecoveredCollectionView.backgroundColor = .clear
        
        return topRecoveredCollectionView
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    private let logoImageView: UIImageView = {
        let logoImage = UIImage(named: "logo")
        
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return logoImageView
    }()
    // MARK: - View LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        animateLogoImageView(duration: 1)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupAutoLayout()
        setupCollectionViews()
        
        dataFetcher.fetchDataFromURl(url: API.worldStatisticsURL!) { (response) in
            if let response = response {
                DispatchQueue.main.sync {
                    self.worldData = response.response.first
                    
                    self.worldCollectionView.performBatchUpdates({
                        let indexSet = IndexSet(integersIn: 0...0)
                        self.worldCollectionView.reloadSections(indexSet)
                    })
                }
                return
            }
        }
        dataFetcher.fetchDataFromURl(url: API.countryStatisticsURL!) { (response) in
            if let response = response {
                DispatchQueue.main.sync {
                    self.data = response.response
                    
                    self.normalizeData(data: &self.data)
                    self.calculateDataSetsForTopCollectionViews(data: self.data)
                    
                    self.reloadCollectionViewsDataWithAnimation()
                }
                return
            }
        }
    }
    func reloadCollectionViewsDataWithAnimation() {
        topCasesCollectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            topCasesCollectionView.reloadSections(indexSet)
        })
        topDeathsCollectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            topDeathsCollectionView.reloadSections(indexSet)
        })
        topRecoveredCollectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            topRecoveredCollectionView.reloadSections(indexSet)
        })
    }
    func normalizeData(data: inout [Response]) {
        //The API I chose includes continents and all data in the list of countries and idk why 🤷🤷🤷
        for (index, _) in data.enumerated().reversed() {
            let country = data[index].country
            
            if country == "All" || country == "North-America" || country == "South-America" || country == "Europe" || country == "Asia" || country == "Africa" || country == "Oceania" || country == "Antarctica" || country == "Australia" || country == "NULL" {
                data.remove(at: index)
            }
        }
    }
    func calculateDataSetsForTopCollectionViews(data: [Response]) {
        let sortedDataByTotalCases = data.sorted { $0.cases.total > $1.cases.total }
        for index in 0 ..< 10 {
            guard sortedDataByTotalCases.indices.contains(index) else { return }
            let statistics = sortedDataByTotalCases[index]
            topCasesStatistics.append(TopStatistics(country: statistics.country, cases: statistics.cases.total, casesToday: statistics.cases.new ?? " no info", title: "Total cases", color: .label))
        }
        
        let sortedDataByTotalDeaths = data.sorted { $0.deaths.total > $1.deaths.total }
        for index in 0 ..< 10 {
            guard sortedDataByTotalDeaths.indices.contains(index) else { return }
            
            let statistics = sortedDataByTotalDeaths[index]
            topDeathsStatistics.append(TopStatistics(country: statistics.country, cases: statistics.deaths.total, casesToday: statistics.deaths.new ?? " no info", title: "Total deaths", color: .red))
        }
        
        let sortedDataByTotalRecovered = data.sorted { $0.cases.recovered > $1.cases.recovered }
        for index in 0 ..< 10 {
            guard sortedDataByTotalRecovered.indices.contains(index) else { return }
            let statistics = sortedDataByTotalRecovered[index]
            topRecoveredStatistics.append(TopStatistics(country: statistics.country, cases: statistics.cases.recovered, casesToday: " no info", title: "Total recovered", color: .green))
        }
    }
    // MARK: - View Setup
    func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(logoImageView)
        
        scrollView.addSubview(worldLabel)
        scrollView.addSubview(worldCollectionView)
        
        worldStackView.addArrangedSubview(worldLabel)
        worldStackView.addArrangedSubview(worldCollectionView)
        scrollView.addSubview(worldStackView)
        
        scrollView.addSubview(topCasesCollectionView)
        scrollView.addSubview(topDeathsCollectionView)
        scrollView.addSubview(topRecoveredCollectionView)
    }
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 55),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
        NSLayoutConstraint.activate([
            worldStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            worldStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            worldStackView.heightAnchor.constraint(equalToConstant: 200),
            worldStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.2)
        ])
        NSLayoutConstraint.activate([
            topCasesCollectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            topCasesCollectionView.topAnchor.constraint(equalTo: worldStackView.bottomAnchor),
            topCasesCollectionView.heightAnchor.constraint(equalToConstant: 150),
            topCasesCollectionView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.2)
        ])
        NSLayoutConstraint.activate([
            topDeathsCollectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            topDeathsCollectionView.topAnchor.constraint(equalTo: topCasesCollectionView.bottomAnchor),
            topDeathsCollectionView.heightAnchor.constraint(equalToConstant: 150),
            topDeathsCollectionView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.2)
        ])
        NSLayoutConstraint.activate([
            topRecoveredCollectionView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            topRecoveredCollectionView.topAnchor.constraint(equalTo: topDeathsCollectionView.bottomAnchor),
            topRecoveredCollectionView.heightAnchor.constraint(equalToConstant: 150),
            topRecoveredCollectionView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.2)
        ])
    }
    func setupCollectionViews() {
        worldCollectionView.delegate = self
        worldCollectionView.dataSource = self
        
        topCasesCollectionView.delegate = self
        topCasesCollectionView.dataSource = self
        
        topDeathsCollectionView.delegate = self
        topDeathsCollectionView.dataSource = self
        
        topRecoveredCollectionView.delegate = self
        topRecoveredCollectionView.dataSource = self
        
        worldCollectionView.register(WorldCollectionViewCell.self, forCellWithReuseIdentifier: "WorldCell")
        topCasesCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "TopCell")
        topDeathsCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "TopCell")
        topRecoveredCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "TopCell")
    }
    func animateLogoImageView(duration: Double) {
        UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: nil)
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == worldCollectionView {
            return 3
        } else {
            return 10
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == worldCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorldCell", for: indexPath) as! WorldCollectionViewCell
            
            if let worldData = worldData {
                cell.initDataForWorldCell(data: worldData, indexPath: indexPath)
                return cell
            } else { return cell }
        } else {
            if !data.isEmpty {
                if collectionView == topCasesCollectionView {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCollectionViewCell
                    cell.initDataForWorldCell(data: topCasesStatistics[indexPath.row])
                    return cell
                } else if collectionView == topDeathsCollectionView {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCollectionViewCell
                    cell.initDataForWorldCell(data: topDeathsStatistics[indexPath.row])
                    return cell
                } else if collectionView == topRecoveredCollectionView {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCollectionViewCell
                    cell.initDataForWorldCell(data: topRecoveredStatistics[indexPath.row])
                    return cell
                }
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCollectionViewCell
        
        return cell
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == worldCollectionView {
            return CGSize(width: UIScreen.main.bounds.width / 2.5, height: 120)
        } else {
            return CGSize(width: UIScreen.main.bounds.width / 1.2, height: 120)
        }
    }
}
