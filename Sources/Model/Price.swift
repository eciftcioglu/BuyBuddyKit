//
//  Price.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 22/05/2017.
//
//

import ObjectMapper


public struct Price: Mappable{
    public var current_price: Float?
    public var discount_price: Float?
    public var ex_price: Float?
    
    public mutating func mapping(map: Map) {
        current_price <- map["current_price"]
        discount_price <- map["discount_price"]
    }
    
    public init?(map: Map) {
        
    }
    
    init(current_price: Float, discount_price: Float, ex_price: Float) {
        self.current_price = current_price
        self.discount_price = discount_price
        self.ex_price = ex_price
    }
}
