//
//  CharacterServiceType.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/9/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation

protocol CharacterServiceType {
    func characters(for page: Int, handler: @escaping ([Character]) -> Void) throws
}
