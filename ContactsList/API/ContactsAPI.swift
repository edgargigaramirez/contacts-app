//
//  ContactsAPI.swift
//  ContactsList
//
//  Created by Ramirez, Edgar on 5/9/18.
//  Copyright © 2018 Ramirez, Edgar. All rights reserved.
//

import Foundation

class ContactsAPI {
    let networkingAPI = NetworkingAPI()
    
    public func getContacts(completion: @escaping (_ contacts: [Contact]?, _ error: NSError?) -> ()) {

        networkingAPI.getDataFromURL(endpoint: "https://s3.amazonaws.com/technical-challenge/v3/contacts.json") { (data, response, error) in
            let decoder = JSONDecoder()
            var contacts: [Contact]?
            
            do {
                if let data = data, let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    contacts = try decoder.decode([Contact].self, from: data)
                }
                
                completion(contacts, nil)
            } catch {
                print(error)
                completion(nil, NSError(domain: error.localizedDescription, code: 0, userInfo: nil))
            }
        }
    }
}
