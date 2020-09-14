//
//  AuthenticationTest.swift
//  MylivnTests
//
//  Created by Yasaman Farahani Saba on 9/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
@testable import Mylivn

class AuthenticationTest: XCTestCase {
    
    var service: Authentication!

    override func setUpWithError() throws {
        self.service = Authentication()
    }

    override func tearDownWithError() throws {
        self.service = nil
    }
    
    func test_hashGenerator() {
        let ts = "1"
        let hash = service.hashGenerator(ts: ts)
        XCTAssertEqual(hash, "44d878b359072047f0b61a5f7094871c")
    }
}
