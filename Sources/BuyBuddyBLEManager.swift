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

class BuyBuddyBLEManager {
    var centralManager : CBCentralManager!
    var bleHandler     : BuyBuddyBleHandler
    
    init(){
        self.bleHandler = BuyBuddyBleHandler()
        //self.centralManager = CBCentralManager(delegate: self.bleHandler, queue: nil)
        
    }
    
    init(products: [ItemData]){
        self.bleHandler = BuyBuddyBleHandler(products: products)
    }
    
}
