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


public struct ItemData: Mappable{
    
    public /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    init?(map: Map) {
        
    }

    public mutating func mapping(map: Map) {
        hitagId     <- map["hitag_id"]
        h_id        <- map["h_id"]
        name        <- map["name"]
        image       <- map["image"]
        metadata    <- map["metadata"]
        id          <- map["id"]
        price       <- map["price"]
        description <- map["description"]
    }
    
    public var hitagId: String?
    public var h_id: Int?
    public var name:String?
    public var id : Int?
    public var metadata: ItemMetaData?
    public var image: String?
    public var realImage: UIImage?
    public var description: String?
    public var price: Price?

    init(){
        
    }
}

