//
//  ComicService.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

struct ComicService: ComicServiceType {
    
    private let context: NSManagedObjectContext
    private let authenticationService: Authentication
    
    init(authentication: Authentication, context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.authenticationService = authentication
        self.context = context
    }
    
    private func today() -> Date {
        let date = Date()
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
    
    func comics(characterId: Int,page: Int, handler: @escaping ([Comic]) -> Void) throws {
        let today = self.today()
        let request: NSFetchRequest<Character> = Character.fetchRequest()
        request.predicate = NSPredicate(format: " %K == %i ", #keyPath(Character.id), characterId)
        let character = try context.fetch(request)
        if character.count != 1 {
            handler([])
            return
        }
        if let comicResults = character.first!.comicResult  {
            let result = comicResults.map{$0 as! ComicResult }.filter{ $0.offset == page * pageSize}
            if result.count == 1, result.first!.fetchDate == today {
                handler(Array( _immutableCocoaArray: result.first!.comics!))
                return
            } else {
                fetchComics(characterId: characterId, page: page, handler: handler)
            }
        }
    }
    
    private func fetchComics(characterId: Int,page: Int, handler: @escaping ([Comic]) -> Void) {
        let ts = String(Date().timeIntervalSince1970)
        let hash = authenticationService.hashGenerator(ts: ts)
        guard let url = URL(string: "https://gateway.marvel.com/v1/public/characters/\(characterId)/comics?ts=\(ts)&apikey=\(authenticationService.publicKey)&hash=\(hash)&offset=\(page * pageSize)") else { fatalError() }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let data = data else { fatalError() }
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = self.context
            do {
                let result = try decoder.decode(ComicResult.self, from: data)
                result.fetchDate = self.today()
                try self.context.save()
                handler(Array(_immutableCocoaArray: result.comics!))
            } catch {
                handler([])
            }
        }
        task.resume()
    }
}
