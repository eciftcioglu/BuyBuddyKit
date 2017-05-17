//
//  OrderDelegateResponse.swift
//  BuyBuddyKit
//
//  Created by Furkan on 5/17/17.
//
//

import Foundation
import ObjectMapper

public class OrderDelegateResponse: Mappable{
    
    var sale_id: Int?
    var delegate_id: Int?
    var employee_id: Int?
    var grand_total: Float?
    var status_flag: Int?
    
    public func mapping(map: Map) {
        sale_id <- map["sale_id"]
        delegate_id <- map["delegate_id"]
        employee_id <- map["employee_id"]
        grand_total <- map["grand_total"]
        status_flag <- map["status_flag"]
    }
    
    required public init?(map: Map) {
        
    }
}
