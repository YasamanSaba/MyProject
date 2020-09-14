//
//  ComicServiceTest.swift
//  MylivnTests
//
//  Created by Yasaman Farahani Saba on 9/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
import CoreData
import UIKit
@testable import Mylivn

class ComicServiceTest: XCTestCase {
    
    var context: NSManagedObjectContext!
    var serviceComic: ComicServiceType!
    var serviceCharacter: CharacterServiceType!

    override func setUpWithError() throws {
        self.context = InMemoryStore().persistentContainer.viewContext
        self.serviceComic = ComicService(authentication: Authentication(), context: self.context)
        self.serviceCharacter = CharacterService(authentication: Authentication(), context: self.context)
    }

    override func tearDownWithError() throws {
        self.context = nil
        self.serviceComic = nil
        self.serviceCharacter = nil
    }
    
    func test_fetch_comics_by_charId() {
        let expectation = self.expectation(description: "Comics")
        XCTAssertNoThrow(try serviceCharacter.characters(for: 0) { characters in
            XCTAssertEqual(characters.count, 20)
            try? self.serviceComic.comics(characterId:Int(characters.first!.id) , page: 0) { comics in
                XCTAssertGreaterThan(comics.count, 0)
                expectation.fulfill()
                }
            })
        
        waitForExpectations(timeout: 15, handler: nil)
    }
}
