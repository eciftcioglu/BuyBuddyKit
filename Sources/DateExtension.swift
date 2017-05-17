//
//  DateExtension.swift
//  BuyBuddyKit
//
//  Created by Furkan on 5/16/17.
//
//

import Foundation

extension Date {
    static var utcTimeStamp: Int{
        let date = Date()
        let dateFormatter = DateFormatter()
        let timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.timeZone = timeZone
        let strDate = dateFormatter.string(from: date)
        let seconds = Int((dateFormatter.date(from: strDate)!.timeIntervalSince1970 * 1000.0).rounded())
        
        return seconds
    }
}
