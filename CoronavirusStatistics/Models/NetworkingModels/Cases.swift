//
//  Cases.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import Foundation

struct Cases: Codable {
    let new: String?
    let active, critical, recovered: Int
    let the1MPop: String?
    let total: Int
}
