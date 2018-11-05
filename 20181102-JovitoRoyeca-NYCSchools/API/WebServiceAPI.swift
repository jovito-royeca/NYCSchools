//
//  WebServiceAPI.swift
//  20181102-JovitoRoyeca-NYCSchools
//
//  Created by Jovito Royeca on 03.11.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import PromiseKit

enum EndPoints {
    static let Schools = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    static let SATResults = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
}

enum Error: Swift.Error {
    case badUrl
    case badResponse(Int)
}

/*
 * This class handles loading data from Web Service or local bundled JSON file.
 */
class WebServiceAPI: NSObject {
    /*
     * Fetch schools from WebService
     */
    func fetchSchools() -> Promise<[[String: Any]]> {
        return Promise { seal  in
            guard let urlString = EndPoints.Schools.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) else {
                return
            }
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "GET"

            firstly {
                URLSession.shared.dataTask(.promise, with: rq)
            }.compactMap {
                try JSONSerialization.jsonObject(with: $0.data) as? [[String: Any]]
            }.done { json in
                seal.fulfill(json)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    /*
     * Fetch SAT results from WebService
     */
    func fetchSATResults() -> Promise<[[String: Any]]> {
        return Promise { seal  in
            guard let urlString = EndPoints.SATResults.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) else {
                    return
            }
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "GET"
            
            firstly {
                URLSession.shared.dataTask(.promise, with: rq)
            }.compactMap {
                try JSONSerialization.jsonObject(with: $0.data) as? [[String: Any]]
            }.done { json in
                seal.fulfill(json)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
