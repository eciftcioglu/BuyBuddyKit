//
//  BuyBuddyBLEManager.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation


import Foundation
import CoreBluetooth

struct HitagResponse{
    public static let Error   = Utilities.dataFrom(hex: "ffff")
    public static let Success = Utilities.dataFrom(hex: "0101")
    public static let Unknown = Utilities.dataFrom(hex: "0202")
}

class BuyBuddyBLEManager {
    var centralManager : CBCentralManager!
    var bleHandler     : BuyBuddyBleHandler
    
    init(){
        self.bleHandler = BuyBuddyBleHandler()
        //self.centralManager = CBCentralManager(delegate: self.bleHandler, queue: nil)
        
    }
    
    init(products: [String:String]){
        self.bleHandler = BuyBuddyBleHandler(products: products)
    }
    
}
