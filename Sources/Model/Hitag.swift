//
//  Hitag.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 03/05/2017.
//
//

import Foundation
import Alamofire
import CoreBluetooth
import UIKit


public class Hitag:CBPeripheral{

    internal(set) public var id: String?
    internal(set) public var major: Int?
    internal(set) public var minor: Int?
    internal(set) public var battery: Float?
    var duty     : HitagDuty!
    var device   : CBPeripheral!
    
    init(name: String, device: CBPeripheral){
        self.device   = device
        id      = name
    }
    
    init?(json: [String:Any]) throws{
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
enum HitagDuty: Int{
    case Open    = 1
    case Control = 2
    case Alert   = 3
    case Test    = 4
}
