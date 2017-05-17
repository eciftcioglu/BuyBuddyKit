//
//  ItemData.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 06/04/2017.
//
//

import Foundation
import Alamofire
import UIKit
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

public struct ItemData: Mappable{
    
    public /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    init?(map: Map) {
        
    }

    public mutating func mapping(map: Map) {
        hitagId     <- map["hitag_id"]
        image_url   <- map["image_url"]
        //data <- map["data"]
        price       <- map["price"]
        description <- map["description"]
    }
    
    public var hitagId: String?
    public var size: String?
    public var color: UIColor?
    public var code: String?
    public var id : Int64?
    public var image_url: String?
    public var description: String?
    public var price: Price?

    init(){
        
    }
}

