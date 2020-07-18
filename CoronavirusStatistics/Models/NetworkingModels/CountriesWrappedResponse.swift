//
//  CountriesWrappedResponse.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 18.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import Foundation

struct CountriesWrappedResponse: Codable {
    let results: Int
    let response: [String]
}
