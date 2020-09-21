//
//  ComicService.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit
import CoreData

class ComicService: ComicServiceType {
    var delegate: ComicServiceDelegateProtocol?
    
    
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
    
    func fetchComics(characterId: Int,page: Int) throws {
        let today = self.today()
        let request: NSFetchRequest<Character> = Character.fetchRequest()
        request.predicate = NSPredicate(format: " %K == %i ", #keyPath(Character.id), characterId)
        let character = try context.fetch(request)
        if character.count != 1 {
            delegate?.comics(fetchedComics: [])
            return
        }
        if let comicResults = character.first!.comicResult  {
            let result = comicResults.map{$0 as! ComicResult }.filter{ $0.offset == page * pageSize}
            if result.count == 1, result.first!.fetchDate == today {
                delegate?.comics(fetchedComics:  result.first!.comics!.allObjects as! [Comic])
                return
            } else {
                fetchComicsFromAPI(characterId: characterId, page: page)
            }
        }
    }
    
    private func fetchComicsFromAPI(characterId: Int, page: Int) {
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
                DispatchQueue.main.async {
                    self.delegate?.comics(fetchedComics: result.comics!.allObjects as! [Comic])
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.comics(fetchedComics: [])
                }
            }
        }
        task.resume()
    }
}
