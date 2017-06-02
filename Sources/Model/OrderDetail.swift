//
//  OrderDetail.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 02/06/2017.
//
//

import Foundation
import ObjectMapper

public struct OrderDetail:Mappable{
    
    public /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        sale_id               <- map["id"]
        total_price           <- map["total_price"]
        total_discount_price  <- map["total_discount_price"]
        total_campaign_price  <- map["total_campaign_price"]
        hitag_ids             <- map["hitag_ids"]

    }
    
    public var sale_id: Int?
    public var total_price: Float?
    public var total_discount_price: Float?
    public var total_campaign_price: Float?
    public var hitag_ids: [String]?

    init(){
        
    }
}
