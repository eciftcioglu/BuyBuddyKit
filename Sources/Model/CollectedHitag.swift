//
//  CollectedHitag.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import ObjectMapper

public class CollectedHitag: Mappable{
    
    internal(set) public var id: String?
    internal(set) public var timeStamp: CFAbsoluteTime?
    internal(set) public var rssi: Int?
    internal(set) public var txPower: Int?
    internal(set) public var validPassCheck: Int?

    
    init(id:String,rssi:Int,txPower:Int?,timeStamp:CFAbsoluteTime?) {
        self.id = id
        self.timeStamp = timeStamp
        self.rssi = rssi
        self.txPower = txPower
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        timeStamp <- map["timestamp"]
        rssi <- map["rssi"]
        txPower <- map["tx_power"]
        validPassCheck <- map["valid_pass_check"]
    }
    
    public required init?(map: Map) {
        
    }
    
    init() {
        
    }
}
