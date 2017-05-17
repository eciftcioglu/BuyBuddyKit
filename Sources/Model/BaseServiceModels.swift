//
//  BBResponse.swift
//  BuyBuddyKit
//
//  Created by Furkan on 5/16/17.
//
//

import Foundation
import ObjectMapper

public class BuyBuddyApiError: Mappable{
    
    var name: String?
    var detail: String?
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        name <- map["name"]
        detail <- map["detail"]
    }
}

public class BuyBuddyBase : Mappable{

    var errors: [BuyBuddyApiError]?
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        errors  <- map["errors"]
    }
}

public class BuyBuddyObject<T:Mappable> : BuyBuddyBase{
    
    var data: T?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}

public class BuyBuddyArray<T:Mappable> : BuyBuddyBase{
    
    var data: [T]?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        data <- map["data"]
    }
}
