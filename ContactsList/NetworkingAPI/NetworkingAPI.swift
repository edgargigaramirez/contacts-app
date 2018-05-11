//
//  NetworkingAPI.swift
//  ContactsList
//
//  Created by Ramirez, Edgar on 5/10/18.
//  Copyright © 2018 Ramirez, Edgar. All rights reserved.
//

import Foundation

class NetworkingAPI {
    public func getDataFromURL(endpoint: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlRequest = URLRequest(url: URL(string: endpoint)!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: urlRequest) { (data, response, error) -> () in
            completionHandler(data, response, error)
        }.resume()
    }
}
