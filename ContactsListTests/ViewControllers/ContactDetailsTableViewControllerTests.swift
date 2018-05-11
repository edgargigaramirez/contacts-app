//
//  ContactDetailsTableViewControllerTests.swift
//  ContactsListTests
//
//  Created by Ramirez, Edgar on 5/10/18.
//  Copyright © 2018 Ramirez, Edgar. All rights reserved.
//

import XCTest
@testable import ContactsList

class ContactDetailsTableViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateContent() {
        let json = """
    {
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
            "mobile": ""
        },
        "address": {
            "street": "1700 Terminal St.",
            "city": "West Sacramento",
            "state": "CA",
            "country": "US",
            "zipCode": "95691"
        }
    }
""".data(using: .utf8)!
        let decoder = JSONDecoder()
        let contact = try! decoder.decode(Contact.self, from: json)
        let vc = ContactDetailsTableViewController()
        let content = vc.createCellsContent(contact)
        
        XCTAssertNotNil(content)
        XCTAssertEqual(content.count, 5)
        
        let emailRow = content[0]
        XCTAssertEqual(emailRow.title, "EMAIL:")
        XCTAssertEqual(emailRow.subtitle, "Pink.Ranger@powerrangers.com")
        XCTAssertEqual(emailRow.phoneNumberType, nil)
        
        let birthdayRow = content[1]
        XCTAssertEqual(birthdayRow.title, "BIRTHDATE:")
        XCTAssertEqual(birthdayRow.subtitle, "Mar 31, 1982")
        XCTAssertEqual(birthdayRow.phoneNumberType, nil)
        
        let homePhoneRow = content[content.count - 2]
        XCTAssertEqual(homePhoneRow.title, "PHONE:")
        XCTAssertEqual(homePhoneRow.subtitle, "916-391-1816")
        XCTAssertEqual(homePhoneRow.phoneNumberType, "Home")
        
        let addressRow = content[content.count - 1]
        XCTAssertEqual(addressRow.title, "ADDRESS:")
        XCTAssertEqual(addressRow.subtitle, "1700 Terminal St.\nWest Sacramento, CA 95691, US")
        XCTAssertNil(addressRow.phoneNumberType)
    }
    
}
