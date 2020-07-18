//
//  Response.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import Foundation

struct Response: Codable {
    let continent: Continent?
    let country: String
    let population: Int?
    let cases: Cases
    let deaths: Deaths
    let tests: Tests
    let day: String
    let time: Date
}

