//
//  Authentication.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/10/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import Foundation
import CryptoKit

struct Authentication {
    private let privateKey = "7a0dde2c7c5d947449a806a2c5a4eff5fe9dd877"
    public let publicKey = "54bd84fa3ee7c971a07d24a4cab600d0"
    
    func hashGenerator(ts: String) -> String {
        let str = ts + privateKey + publicKey
        let data = str.data(using: .utf8)
        let digest = Insecure.MD5.hash(data: data!)
        return digest.map{
            String(format: "%02hhx", $0)
        }.joined()
    }
}
