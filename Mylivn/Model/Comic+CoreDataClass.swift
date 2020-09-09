//
//  Comic+CoreDataClass.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/8/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Comic)
public class Comic: NSManagedObject, Codable {
    
    private enum ComicKeys: String, CodingKey {
        case id = "id"
        case desc = "description"
        case img = "thumbnail"
        case title = "title"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "Comic", in: context) else { fatalError() }
        let container = try decoder.container(keyedBy: ComicKeys.self)
        self.init(entity: entity, insertInto: context)
        
        id = try container.decode(Int64.self, forKey: .id)
        desc = try container.decode(String.self, forKey: .desc)
        img = try container.decode(URL.self, forKey: .img)
        title = try container.decode(String.self, forKey: .title)
    }
}
