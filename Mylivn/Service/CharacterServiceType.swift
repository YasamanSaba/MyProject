//
//  CharacterServiceType.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/9/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol CharacterServiceType {
    var delegate: CharacterServiceDelegateProtocol? { get set }
    mutating func fetchCharacters(for page: Int) throws
}

protocol CharacterServiceDelegateProtocol {
    mutating func characters(fetchedCharacters: [Character])
}
