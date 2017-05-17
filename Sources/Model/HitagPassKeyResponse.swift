//
//  HitagPassKeyResponse.swift
//  BuyBuddyKit
//
//  Created by Furkan on 5/17/17.
//
//

import Foundation
import ObjectMapper

class HitagPassKeyResponse: Mappable{
    var sale_id: Int?
    var hitag_passkeys: [String : String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        sale_id <- map["sale_id"]
        hitag_passkeys <- map["hitag_passkeys"]
    }
}
