//
//  ComicServiceType.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/13/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol ComicServiceType {
    func comics(characterId: Int,page: Int, handler: @escaping ([Comic]) -> Void) throws
}
