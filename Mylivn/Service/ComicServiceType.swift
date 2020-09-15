//
//  ComicServiceType.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol ComicServiceType {
    var delegate: ComicServiceDelegateProtocol? { get set }
    mutating func fetchComics(characterId: Int,page: Int) throws
}

protocol ComicServiceDelegateProtocol {
    mutating func comics(fetchedComics: [Comic])
}
