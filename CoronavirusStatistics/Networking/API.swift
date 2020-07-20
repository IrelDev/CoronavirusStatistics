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
    
    static let countryStatisticsURL = URL(string: "https://covid-193.p.rapidapi.com/statistics")
    static let worldStatisticsURL = URL(string: "https://covid-193.p.rapidapi.com/statistics?country=all")
    static let countryListURL = URL(string: "https://covid-193.p.rapidapi.com/countries")
    
    static func createLinkForCountry(country: String) -> URL? {
        let stringUrl = API.countryStatisticsURL!.absoluteString + "?country=\(country.lowercased())"
        let url = URL(string: stringUrl)
        
        return url
    }
}
