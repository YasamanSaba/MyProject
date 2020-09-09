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
    
    
    private struct Thumbnail: Decodable {
        let path: String
        let fileExtension: String
        
        private enum ThumbnailKeys: String, CodingKey {
            case path
            case fileExtension = "extension"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: ThumbnailKeys.self)
            path = try container.decode(String.self, forKey: .path)
            fileExtension = try container.decode(String.self, forKey: .fileExtension)
        }
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CharacterKeys.self)
        guard let entity = NSEntityDescription.entity(forEntityName: "Character", in: context) else { fatalError() }
        self.init(entity: entity, insertInto: context)
        
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int64.self, forKey: .id)
        let thumbnail = try container.decode(Thumbnail.self, forKey: .img)
        let path = thumbnail.path + "." + thumbnail.fileExtension
        img = URL(fileURLWithPath: path)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
