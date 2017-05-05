//
//  Hitag.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 03/05/2017.
//
//

import Foundation
import Alamofire

public struct Hitag{

    internal(set) public var id: String?
    internal(set) public var major: Int?
    internal(set) public var minor: Int?
    internal(set) public var battery: Float?
    
    
     public init?(json: [String:Any]) throws{
        guard
            let id = json["id"] as? String,
            let major = json["major"] as? Int,
            let minor = json["minor"] as? Int,
            let battery = json["battery"] as? Float
            else { return nil }
        
            self.id = id
            self.major = major
            self.minor = minor
            self.battery = battery
    }
}
