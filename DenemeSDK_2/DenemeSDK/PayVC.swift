//
//  PayVC.swift
//  DenemeSDK
//
//  Created by Emir Çiftçioğlu on 22/05/2017.
//  Copyright © 2017 BuyBuddy. All rights reserved.
//

import Foundation
import UIKit
import BuyBuddyKit

class PayVC:UIViewController,BuyBuddyHitagReleaserDelegate{
    
    var orderId:Int?
    var basketTotal:Float?


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func test(_ sender: Any) {
        //BuyBuddyViewManager.callPaymentFinalizerView(viewController: self, orderId: orderId)
        
        BuyBuddyApi.sharedInstance.getOrderDetail(saleId: orderId!, success: { (item:BuyBuddyObject<OrderDetail>, httpResponse) in
            
            if let data = item.data{
                BuyBuddyHitagReleaser(orderDetails: data, delegate: self)
            }
            
        }, error: { (err, httpResponse) in
            
        })
    }
    
    func hitagReleaseSuccess() {
        print("Success")
    }
    
    func hitagReleaseError() {
        
    }
}
