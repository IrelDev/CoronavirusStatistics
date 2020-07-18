//
//  DataFetcher.swift
//  CoronavirusStatistics
//
//  Created by Kirill Pustovalov on 17.07.2020.
//  Copyright © 2020 Kirill Pustovalov. All rights reserved.
//

import Foundation

struct DataFetcher {
    func fetchDataFromURl<Type: Codable>(url: URL, completion: @escaping (Type?) -> Void) {
        let headers = [
            "x-rapidapi-host": API.host,
            "x-rapidapi-key": API.key
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error ) in
            guard error == nil else { print(debugPrint(error!)); return }
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            
            let wrappedResponse = try? jsonDecoder.decode(Type.self, from: data)
            
            completion(wrappedResponse)
        }
        dataTask.resume()
    }
}
