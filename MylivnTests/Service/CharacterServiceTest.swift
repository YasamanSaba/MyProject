//
//  CharacterServiceTest.swift
//  MylivnTests
//
//  Created by Yasaman Farahani Saba on 9/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
@testable import Mylivn

class CharacterServiceTest: XCTestCase {
    var service: CharacterServiceType!

    override func setUpWithError() throws {
        self.service = CharacterService(authentication: Authentication())
    }

    override func tearDownWithError() throws {
        self.service = nil
    }
    
    func test_characters() {
        let expectation = self.expectation(description: "Characters")
        XCTAssertNoThrow(try service.characters(for: 0) { characters in
            XCTAssertEqual(characters.count, 20)
            expectation.fulfill()
            })
     
        waitForExpectations(timeout: 15, handler: nil)
    }
}
