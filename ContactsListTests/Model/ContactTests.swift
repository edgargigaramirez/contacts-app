//
//  ContactTests.swift
//  ContactsListTests
//
//  Created by Ramirez, Edgar on 5/9/18.
//  Copyright © 2018 Ramirez, Edgar. All rights reserved.
//

import XCTest
@testable import ContactsList

class ContactTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecode() {
        let json = """
    [{
        "name": "Pink Ranger",
        "id": "15",
        "companyName": "Power Rangers",
        "isFavorite": false,
        "smallImageURL": "https://s3.amazonaws.com/technical-challenge/v3/images/pink-ranger-small.jpg",
        "largeImageURL": "https://s3.amazonaws.com/technical-challenge/v3/images/pink-ranger-large.jpg",
        "emailAddress": "Pink.Ranger@powerrangers.com",
        "birthdate": "1982-03-31",
        "phone": {
            "work": "916-372-5031",
            "home": "916-391-1816",
            "mobile": "771-881-8381"
        },
        "address": {
            "street": "1700 Terminal St.",
            "city": "West Sacramento",
            "state": "CA",
            "country": "US",
            "zipCode": "95691"
        }
    }]
""".data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let contacts = try! decoder.decode([Contact].self, from: json)
        let contact = contacts[0]
        
        XCTAssertNotNil(contact)
        XCTAssertEqual(contact.name, "Pink Ranger")
        XCTAssertEqual(contact.address!["street"], "1700 Terminal St.")
    }
    
}
