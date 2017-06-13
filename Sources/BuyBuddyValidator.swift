//
//  BuyBuddyValidator.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 24/05/2017.
//
//

import Foundation


public class BuyBuddyHitagValidator{

    public static func isValidPatternForHitag(hitagId: String) -> String? {
        
        let regexStr = "([0-9A-Fa-f]{2})[-]([0-9A-Fa-f]{4})[-]([0-9A-Fa-f]{4})"
        let regex = try! NSRegularExpression(pattern: regexStr, options: [])
        
        let matches = regex.matches(in: hitagId, options: [], range: NSRange(location: 0, length: hitagId.characters.count))
        
        if matches.count == 1 && hitagId.characters.count == 12 {
            let replacedHitagId = hitagId.replacingOccurrences(of: "-", with: "")
            return replacedHitagId
            
        }else{
            return nil
        }
    }
}
