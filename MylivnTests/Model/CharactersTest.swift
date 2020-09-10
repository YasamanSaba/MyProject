//
//  CharactersTest.swift
//  MylivnTests
//
//  Created by Yasaman Farahani Saba on 9/9/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
import UIKit
import CoreData
@testable import Mylivn

class CharactersTest: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        self.context = InMemoryStore().persistentContainer.viewContext
    }

    override func tearDownWithError() throws {
        self.context = nil
    }
    
    func test_character_decode() {
        let fileUrl = Bundle(for: type(of: self)).url(forResource: "Characters", withExtension: "json")
        let data = try! Data(contentsOf: fileUrl!)
        XCTAssertNotNil(data)
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = context
        let characterResult = try? decoder.decode(CharacterResult.self, from: data)
        XCTAssertNotNil(characterResult)
        XCTAssertNotNil(characterResult!.characters)
        XCTAssertEqual(characterResult!.characters?.count, 20)
    }
    
    func test_save_character_to_coredata() {
        let fileUrl = Bundle(for: type(of: self)).url(forResource: "Characters", withExtension: "json")
        let data = try! Data(contentsOf: fileUrl!)
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = context
        let result = try? decoder.decode(CharacterResult.self, from: data)
        result?.fetchDate = Date()
        XCTAssertNoThrow(try self.context.save())
        let characterRequest = NSFetchRequest<NSNumber>(entityName: "Character")
        characterRequest.resultType = .countResultType
        let characterCount = try? context.fetch(characterRequest)
        XCTAssertNotNil(characterCount)
        XCTAssertEqual(characterCount!.first!.intValue, 20)
        
        let characterResultRequest = NSFetchRequest<NSNumber>(entityName: "CharacterResult")
        characterResultRequest.resultType = .countResultType
        let characterResultCount = try? context.fetch(characterResultRequest)
        XCTAssertNotNil(characterResultCount)
        XCTAssertEqual(characterResultCount!.first!.intValue, 1)
    }
}
