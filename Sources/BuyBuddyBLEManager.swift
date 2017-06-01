//
//  BuyBuddyBLEManager.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import CoreBluetooth
import UIKit

struct HitagResponse{
    public static let Error   = Utilities.dataFrom(hex: "ffff")
    public static let Success = Utilities.dataFrom(hex: "0101")
    public static let Unknown = Utilities.dataFrom(hex: "0202")
    public static let Starting = Utilities.dataFrom(hex: "0103")
    public static let ValidationSuccess = Utilities.dataFrom(hex: "0102")    
}

class BuyBuddyBLEManager {
    var centralManager : CBCentralManager!
    var bleHandler     : BuyBuddyBleHandler
    
    init(){
        self.bleHandler = BuyBuddyBleHandler()        
    }
    
    init(hitagId:String,viewController:BluetoothConnectionDelegate) {
        self.bleHandler = BuyBuddyBleHandler(hitagId: hitagId,viewController:viewController)
    }
}
