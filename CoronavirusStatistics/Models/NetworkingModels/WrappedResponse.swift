//
//  WrappedResponse.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import Foundation

struct WrappedResponse: Codable {
    let results: Int
    let response: [Response]
}
