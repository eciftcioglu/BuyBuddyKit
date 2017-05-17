//
//  BuyBuddyJwt.swift
//  BuyBuddyKit
//
//  Created by Furkan on 5/16/17.
//
//

import Foundation
import ObjectMapper

struct BuyBuddyUserJwt: Mappable{
    
    static func getCurrentJwt() -> BuyBuddyUserJwt?{
        if let jwt = Utilities.getFromUd(key: "user_jwt") as? Dictionary<String, Any>{
            return BuyBuddyUserJwt(fromDict: jwt)
        }
        return nil
    }
    
    static func setCurrentJwt(jwt: BuyBuddyUserJwt){
        let dict = jwt.toDict()
        Utilities.saveToUd(key: "user_jwt", value: dict)
    }

    var jwt: String = ""
    //var exp: String?
    var user_id: Int?
    var passphrase_id: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        jwt <- map["jwt"]
        //exp <- map["exp"]
        user_id <- map["user_id"]
        passphrase_id <- map["passphrase_id"]
    }
    
    init(fromDict: Dictionary<String, Any>){
        self.jwt = fromDict["jwt"] == nil ? "" : (fromDict["jwt"] as! String)
        //self.exp = fromDict["exp"]
        self.user_id = fromDict["user_id"] as? Int
        self.passphrase_id = fromDict["passphrase_id"] as? Int
    }
    
    func toDict() -> Dictionary<String, Any> {
        var jwtDict = Dictionary<String, Any>()
        
        jwtDict.updateValue(jwt, forKey: "jwt")
        
        //if exp != nil{
          //  jwtDict.updateValue(exp!, forKey: "exp")
        //}
        
        if user_id != nil{
            jwtDict.updateValue(user_id!, forKey: "user_id")
        }
        
        if passphrase_id != nil{
            jwtDict.updateValue(passphrase_id!, forKey: "passphrase_id")
        }
        
        return jwtDict
    }
}
