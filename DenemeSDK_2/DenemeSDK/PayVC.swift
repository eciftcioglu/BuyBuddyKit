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

class PayVC:UIViewController{
    
    var orderId:Int?
    var basketTotal:Float?


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func test(_ sender: Any) {
        BuyBuddyViewManager.callPaymentFinalizerView(viewController: self, orderId: orderId, hitagIds: ["0100000001","0100000002"])

    }
 
}
