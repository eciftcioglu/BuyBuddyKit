//
//  Utilities.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 09/05/2017.
//
//

import Foundation
class Utilities{
    
    /*
     class func qrFilter(){
     let phoneNumber = "01-0000-0001"
     if phoneNumber =~ "?\\[A-Fa-f0-9]{2}-?\\s\\[A-Fa-f0-9]{4}-\\[A-Fa-f0-9]{4}" {
     println("That looks like a valid US phone number")
     }
     }*/
    
    class func dataFrom(hex: String) -> Data {
        var hex = hex
        var data = Data()
        while(hex.characters.count > 0) {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
}
