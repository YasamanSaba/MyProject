//
//  CharacterService.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/9/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class CharacterService: CharacterServiceType {
    
    var delegate: CharacterServiceDelegateProtocol?
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
    
    func fetchCharacters(for page: Int) throws {
        let today = self.today()
        let request: NSFetchRequest<CharacterResult> = CharacterResult.fetchRequest()
        request.predicate = NSPredicate(format: " %K = %i ", #keyPath(CharacterResult.offset), page * pageSize)
        let result = try context.fetch(request)
        if result.count > 0 {
            if result.first!.fetchDate == today {
                result.first!.characters == nil ? delegate?.characters(fetchedCharacters: []) :
                    delegate?.characters(fetchedCharacters: result.first!.characters!.allObjects as! [Character])
                return
            } else {
                context.delete(result.first!)
            }
        }
        fetchCharactersFromAPI(for: page)
    }
    
    private func fetchCharactersFromAPI(for page: Int) {
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
                    self.delegate?.characters(fetchedCharacters: [])
                } else {
                    result.fetchDate = self.today()
                    try self.context.save()
                    var characterList: [Character] = []
                    result.characters?.forEach{
                        characterList.append($0 as! Character)
                    }
                    self.delegate?.characters(fetchedCharacters: characterList)
                }
            } catch {
                self.delegate?.characters(fetchedCharacters: [])
            }
        }
        task.resume()
    }
}
