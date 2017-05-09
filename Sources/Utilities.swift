//
//  Utilities.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 09/05/2017.
//
//

import Foundation
class Utilities{
    
    class func qrFilter(){
        let phoneNumber = "01-0000-0001"
        if phoneNumber =~ "?\\[A-Fa-f0-9]{2}-?\\s\\[A-Fa-f0-9]{4}-\\[A-Fa-f0-9]{4}" {
            println("That looks like a valid US phone number")
        }
    }
}
