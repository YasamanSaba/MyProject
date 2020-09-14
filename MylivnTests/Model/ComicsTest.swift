//
//  ComicsTest.swift
//  MylivnTests
//
//  Created by Yasaman Farahani Saba on 9/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import XCTest
import CoreData
@testable import Mylivn

class ComicsTest: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        self.context = InMemoryStore().persistentContainer.viewContext
    }

    override func tearDownWithError() throws {
        self.context = nil
    }
    
    func test_comic_decode() {
        let fileUrl = Bundle(for: type(of: self)).url(forResource: "Comics", withExtension: "json")
        let data = try! Data(contentsOf: fileUrl!)
        XCTAssertNotNil(data)
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = context
        let comicResult = try? decoder.decode(ComicResult.self, from: data)
        XCTAssertNotNil(comicResult)
        XCTAssertNotNil(comicResult!.comics)
        XCTAssertGreaterThan(comicResult!.comics!.count, 0)
    }
    
    func test_save_comic_to_coredata() {
        let fileUrl = Bundle(for: type(of: self)).url(forResource: "Comics", withExtension: "json")
        let data = try! Data(contentsOf: fileUrl!)
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = context
        let result = try? decoder.decode(ComicResult.self, from: data)
        result?.fetchDate = Date()
        XCTAssertNoThrow(try self.context.save())
        let comicRequest = NSFetchRequest<NSNumber>(entityName: "Comic")
        comicRequest.resultType = .countResultType
        let comicCount = try? context.fetch(comicRequest)
        XCTAssertNotNil(comicCount)
        XCTAssertGreaterThan(comicCount!.first!.intValue, 0)
        
        let comicResultRequest = NSFetchRequest<NSNumber>(entityName: "ComicResult")
        comicResultRequest.resultType = .countResultType
        let comicResultCount = try? context.fetch(comicResultRequest)
        XCTAssertNotNil(comicResultCount)
        XCTAssertEqual(comicResultCount!.first!.intValue, 1)
    }  
}
