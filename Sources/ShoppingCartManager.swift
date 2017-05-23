//
//  ShoppingCartManager.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//
//

import Foundation


public class ShoppingBasketManager {
    public static let shared = ShoppingBasketManager()
    public var basket: [String:ItemData] = [:]
    
    private init() {
        
    }
}
