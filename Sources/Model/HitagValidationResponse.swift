//
//  HitagValidationResponse.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 25/05/2017.
//
//

import Foundation
import ObjectMapper

class HitagValidationResponse: Mappable{
    var id:Int?
    var sale_id: Int?
    var hitag_id: String?
    var compiled_id: String?
    var status: Int?
    var inserted_at:String?
    var updated_at:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        sale_id <- map["sale_id"]
        hitag_id <- map["hitag_id"]
        compiled_id <- map["compiled_id"]
        status <- map["status"]
        inserted_at <- map["inserted_at"]
        updated_at <- map["updated_at"]

    }
}
