//
//  CharacterResult+CoreDataClass.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/9/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CharacterResult)
public class CharacterResult: NSManagedObject, Codable {
    
    private enum OuterKeys: String, CodingKey {
        case data
    }
    
    private enum CharacterKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        let outer = try decoder.container(keyedBy: OuterKeys.self)
        let container = try outer.nestedContainer(keyedBy: CharacterKeys.self, forKey: .data)
        guard let entity = NSEntityDescription.entity(forEntityName: "CharacterResult", in: context) else { fatalError() }
        self.init(entity: entity, insertInto: context)
        offset = try container.decode(Int32.self, forKey: .offset)
        limit = try container.decode(Int32.self, forKey: .limit)
        total = try container.decode(Int32.self, forKey: .total)
        count = try container.decode(Int32.self, forKey: .count)
        let tempCharacters = try container.decode([Character].self, forKey: .results)
        tempCharacters.forEach{ addToCharacters($0)}
    }
}
