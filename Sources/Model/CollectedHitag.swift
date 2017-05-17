//
//  CollectedHitag.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation


public class CollectedHitag{
    
    internal(set) public var id: String?
    internal(set) public var timeStamp: CFAbsoluteTime?
    internal(set) public var rssi: Int?
    internal(set) public var txPower: Int?

    
    init(id:String,rssi:Int,txPower:Int?,timeStamp:CFAbsoluteTime?) {
        self.id = id
        self.timeStamp = timeStamp
        self.rssi = rssi
        self.txPower = txPower
        
    }
    init() {
        
    }
    init?(json: [String:Any]) throws{
        guard
            let id = json["id"] as? String,
            let rssi = json["rssi"] as? Int,
            let txPower = json["txPower"] as? Int
            else { return nil }
        
        self.id = id
        self.rssi = rssi
        self.txPower = txPower

    }
}
