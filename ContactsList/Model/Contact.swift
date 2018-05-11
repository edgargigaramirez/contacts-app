//
//  Contact.swift
//  ContactsList
//
//  Created by Ramirez, Edgar on 5/9/18.
//  Copyright © 2018 Ramirez, Edgar. All rights reserved.
//

import Foundation

class Contact: Decodable {
    var name: String?
    var id: String?
    var companyName: String?
    var isFavorite: Bool?
    var smallImageURL: String?
    var largeImageURL: String?
    var emailAddress: String?
    var birthdate: String?
    var phone: [String: String]?
    var address: [String: String]?
    
//    private enum CodingKeys: String, CodingKey {
//        case name
//        case id
//        case companyName
//        case isFavorite
//        case smallImageURL
//        case largeImageURL
//        case emailAddress: String
//        case birthdate: String
//        case phone: [String: String]
//        case address: [String: String]
//    }
}
