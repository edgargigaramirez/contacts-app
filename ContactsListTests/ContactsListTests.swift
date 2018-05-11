//
//  ContactsListTests.swift
//  ContactsListTests
//
//  Created by Ramirez, Edgar on 5/9/18.
//  Copyright © 2018 Ramirez, Edgar. All rights reserved.
//

import XCTest
@testable import ContactsList

class ContactsListTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSortedList() {
        let json = """
    [
    {
        "name": "Pink Ranger"
    },
    {
        "name": "Arthur Clark"
    },
    {
        "name": "John Wayne"
    },
    ]
""".data(using: .utf8)!
        let controller = MainViewController()
        let decoder = JSONDecoder()
        let contacts = try! decoder.decode([Contact].self, from: json)
        let contactsOrdered = controller.sortContactsAlphabetically(contacts)
        
        XCTAssertEqual(contactsOrdered[0].name, "Arthur Clark")
        XCTAssertEqual(contactsOrdered[1].name, "John Wayne")
        XCTAssertEqual(contactsOrdered[2].name, "Pink Ranger")
    }
    
    func testFilterByFavorites() {
        let json = """
    [
    {
        "name": "Pink Ranger",
        "isFavorite": false
    },
    {
        "name": "Arthur Clark"
    },
    {
        "name": "John Wayne",
        "isFavorite": true
    },
    ]
""".data(using: .utf8)!
        let controller = MainViewController()
        let decoder = JSONDecoder()
        let contacts = try! decoder.decode([Contact].self, from: json)
        let (favoriteContacts, unfavoriteContacts) = controller.splitByFavorites(contacts)
        let contactsFavsFirst = favoriteContacts + unfavoriteContacts
        
        XCTAssertEqual(contacts.count, 3)
        XCTAssertEqual(favoriteContacts.count, 1)
        XCTAssertEqual(unfavoriteContacts.count, 2)
        XCTAssertEqual(contactsFavsFirst.count, 3)
    }
    
}
