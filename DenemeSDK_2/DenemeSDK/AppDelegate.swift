//
//  AppDelegate.swift
//  DenemeSDK
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//  Copyright © 2017 BuyBuddy. All rights reserved.
//

import UIKit
import BuyBuddyKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BuyBuddyInvalidTokenDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BuyBuddyHitagManager.startHitagManager()
        BuyBuddyApi.sharedInstance.sandBoxMode(isActive: true)
        BuyBuddyApi.sharedInstance.set(invalidTokenDelegate: self)
        BuyBuddyApi.sharedInstance.set(accessToken: "Z/+dSDxiTYCBXP60B5VVsuFFVfkm/0XZmmYF32fZT0AKETSpw15KT7xoG6moW44wTcxRz86zQP+YiTMO2nJPmA==")
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            BuyBuddyApi.sharedInstance.getProductWith(hitagId: "0Z00000001", success: { (item, response) in
                print(item)
            }) { (err, response) in
                print(err)
            }
        }
        
        let when2 = DispatchTime.now() + 10 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when2) {
            BuyBuddyApi.sharedInstance.createOrder(hitagsIds: [1], sub_total: 103.75, success: { (orderResponse, httpResponse) in
                
            }, error: { (err, httpResponse) in
                
            })
        }
        
        BuyBuddyApi.sharedInstance

        
        
        return true
    }
    
    func tokenExpired() {
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
      
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

