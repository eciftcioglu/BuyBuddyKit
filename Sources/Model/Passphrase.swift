//
//  Passphrase.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 06/04/2017.
//
//

import Foundation

public class Passphrase {
    private let passkey: String
    public let insertedAt: Date
    
    init(passkey: String, insertedAt: Date) {
        self.passkey = passkey
        self.insertedAt = insertedAt
    }
}
