//
//  ComicResult+CoreDataClass.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ComicResult)
public class ComicResult: NSManagedObject, Codable {
    
    enum OuterKeys: String, CodingKey {
        case data
    }
    
    enum ComicKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        let outer = try decoder.container(keyedBy: OuterKeys.self)
        let container = try outer.nestedContainer(keyedBy: ComicKeys.self, forKey: .data)
        guard let entity = NSEntityDescription.entity(forEntityName: "ComicResult", in: context) else { fatalError() }
        self.init(entity: entity, insertInto: context)
        offset = try container.decode(Int32.self, forKey: .offset)
        limit = try container.decode(Int32.self, forKey: .limit)
        total = try container.decode(Int32.self, forKey: .total)
        count = try container.decode(Int32.self, forKey: .count)
        let results = try container.decode([Comic].self, forKey: .results)
        results.forEach { addToComics($0) }
    }
}
