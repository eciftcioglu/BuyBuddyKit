//
//  IncompleteOrder.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 29/05/2017.
//
//

import Foundation
import ObjectMapper

public struct IncompleteOrderResponse:Mappable{
    
    public var sale_id: Int?
    public var hitag_ids: [String]?
    public var hitag_completion_count: Int?
    public var hitag_count: Int?
    public var status_flag: Int?
    public var inserted_at: Date?

    public /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        sale_id     <- map["sale_id"]
        hitag_ids   <- map["hitag_ids"]
        hitag_completion_count   <- map["hitag_completion_count"]
        hitag_count <- map["hitag_count"]
        status_flag <- map["status_flag"]
        inserted_at <- map["inserted_at"]

    }
    
    init(){
        
    }
}
