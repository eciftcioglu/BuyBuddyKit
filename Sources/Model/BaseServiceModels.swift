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
    
    var tracemessage: String?
    var tracecode: String?
    
    required public init?(map: Map) {
        
    }
    
    init(tracemessage:String,tracecode:String?) {
        self.tracemessage = tracemessage
        self.tracecode = tracecode
    }
    
    public func mapping(map: Map) {
        tracecode    <- map["tracecode"]
        tracemessage <- map["tracemessage"]
    }
}

public class BuyBuddyBase : Mappable{

    var errors: BuyBuddyApiError?

    required public init?(map: Map) {}
    
    init(error:BuyBuddyApiError) {
        self.errors = error
    }
    
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
