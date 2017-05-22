//
//  ItemMetaData.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 22/05/2017.
//
//

import Foundation
import ObjectMapper

public struct ItemMetaData:Mappable{
    
    public /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    init?(map: Map) {
        
    }
    
    public mutating func mapping(map: Map) {
        color  <- map["color"]
        size   <- map["size"]
        code   <- map["code"]

    }
    
    public var color: String?
    public var size: String?
    public var code: Int?
    
    init(){
        
    }
}
