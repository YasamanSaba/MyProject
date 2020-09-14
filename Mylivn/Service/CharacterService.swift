//
//  CharacterService.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/9/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

struct CharacterService: CharacterServiceType {
    
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
    
    func characters(for page: Int, handler: @escaping ([Character]) -> Void) throws {
        let today = self.today()
        let request: NSFetchRequest<CharacterResult> = CharacterResult.fetchRequest()
        request.predicate = NSPredicate(format: " %K = %i ", #keyPath(CharacterResult.offset), page * pageSize)
        let result = try context.fetch(request)
        if result.count > 0 {
            if result.first!.fetchDate == today {
                result.first!.characters == nil ? handler([]) : handler(Array(_immutableCocoaArray: result.first!.characters!))
                return
            } else {
                context.delete(result.first!)
            }
        }
        fetchCharacters(for: page, handler: handler)
    }
    
    private func fetchCharacters(for page: Int, handler: @escaping ([Character]) -> Void) {
        let ts = String(Date().timeIntervalSince1970)
        let hash = authenticationService.hashGenerator(ts: ts)
        guard let url = URL(string: "https://gateway.marvel.com/v1/public/characters?ts=\(ts)&apikey=\(authenticationService.publicKey)&hash=\(hash)&offset=\(page * pageSize)") else { fatalError() }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let data = data else { fatalError() }
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = self.context
            do {
                let result = try decoder.decode(CharacterResult.self, from: data)
                if result.characters == nil {
                    handler([])
                } else {
                    result.fetchDate = self.today()
                    try self.context.save()
                    var characterList: [Character] = []
                    result.characters?.forEach{
                        characterList.append($0 as! Character)
                    }
                    handler(characterList)
                }
            } catch {
                handler([])
            }
        }
        task.resume()
    }
}
