//
//  ItemData.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 06/04/2017.
//
//

import Foundation
import Alamofire
import UIKit

public struct ItemData {
    
    public var hitagId: String?
    public var size: String?
    public var color: UIColor?
    public var code: String?
    public var id : Int64?
    public var image: UIImage?
    public var price: Float?

    init(hitagId: String){
        self.hitagId = hitagId
    }
    
    init() {
    }
    init?(json: [String:Any]) throws{
        guard let size = json["size"] as? String,
            let hitagId = json["hitagId"] as? String,
            let color = json["color"] as? UIColor,
            let code = json["code"] as? String,
            let id = json["id"] as? Int64,
            let price = json["price"] as? Float,
            let image = json["image"] as? UIImage
        else { return nil }
        
        self.size = size
        self.hitagId = hitagId
        self.color = color
        self.code = code
        self.id = id
        self.image = image
        self.price = price
    }
}

