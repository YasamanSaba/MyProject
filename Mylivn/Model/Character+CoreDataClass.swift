//
//  Character+CoreDataClass.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/8/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Character)
public class Character: NSManagedObject, Codable {
    
    private enum CharacterKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case img = "thumbnail"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CharacterKeys.self)
        guard let entity = NSEntityDescription.entity(forEntityName: "Character", in: context) else { fatalError() }
        self.init(entity: entity, insertInto: context)
        
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int64.self, forKey: .id)
        img = try container.decode(URL.self, forKey: .img)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
