//
//  ItemData.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 06/04/2017.
//
//

import Foundation
import Alamofire

public struct ItemData {
    public var size: String?
    public var color: String?
    public var code: String?
    public var id : Int64?
    

    init?(json: [String:Any]) throws{
        guard let size = json["size"] as? String,
            let color = json["color"] as? String,
            let code = json["code"] as? String,
            let id = json["id"] as? Int64
        else { return nil }
        
        self.size = size
        self.color = color
        self.code = code
        self.id = id
    }
}

