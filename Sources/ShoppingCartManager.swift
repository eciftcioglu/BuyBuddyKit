//
//  ShoppingCartManager.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//
//

import Foundation


public class ShoppingCartManager {
    public static let shared = ShoppingCartManager()
    public var basket: [String:ItemData] = [:]
    
    private init() {
        
    }
    
}
