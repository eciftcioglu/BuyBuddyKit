//
//  ShoppingCartManager.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//
//

import Foundation


class ShoppingCartManager {
    static let shared = ShoppingCartManager()
    var basket: [String:ItemData] = [:]
    
    private init() {
        
    }
    
}
