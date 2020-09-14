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
        case id
        case description
        case thumbnail
        case title
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
        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "Comic", in: context) else { fatalError() }
        let container = try decoder.container(keyedBy: ComicKeys.self)
        self.init(entity: entity, insertInto: context)
        
        id = try container.decode(Int64.self, forKey: .id)
        desc = try container.decode(String?.self, forKey: .description)
        title = try container.decode(String?.self, forKey: .title)
        let thumbnail = try container.decode(Thumbnail.self, forKey: .thumbnail)
        let path = thumbnail.path + "." + thumbnail.fileExtension
        img = URL(string: path)
    }
}
