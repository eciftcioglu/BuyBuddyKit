//
//  main.swift
//  BuyBuddyKit
//
//  Created by Buğra Ekuklu on 25.02.2017.
//
//

import Foundation
import BuyBuddyKit

struct Delegate: PassphraseFactoryDelegate {
    func didFetchPassphrase() {
        
    }
}

let delegate = Delegate()
let factory = PassphraseFactory(delegate: delegate)

factory.createPassphrase(withCredentials: Credentials(username: "", password: ""))
