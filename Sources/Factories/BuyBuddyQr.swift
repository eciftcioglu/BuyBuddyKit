//
//  HitagScanFactory.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 03/05/2017.
//
//

import Foundation
import Alamofire

protocol BuyBuddyQrDelegate{
    
}

public class BuyBuddyQr {

     public var delegate: ProductScanFactoryDelegate!
    
     public init(delegate: ProductScanFactoryDelegate?) {
        self.delegate = delegate
    }
    
    public func getProduct(withHitagId id: String) {
        var statusCode: Int = 0
        let url = "http://192.168.1.47:4000/api/iot/scan/" + id
        Alamofire.request(url,
                          method: .post,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                statusCode = (response.response?.statusCode)!
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                print("Status Code: \(String(describing: statusCode))")
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
        }
    }
}
