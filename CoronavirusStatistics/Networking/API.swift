//
//  API.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import Foundation

struct API {
    static let host = "covid-193.p.rapidapi.com"
    static let key = "271f3bd7e5mshd35849405369bb8p1c9877jsn65bdc30e2c25"
    
    static let countryStatisticsURL = URL(string: "https://covid-193.p.rapidapi.com/statistics?")
    static let worldStatisticsURL = URL(string: "https://covid-193.p.rapidapi.com/statistics?country=all")
}
