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
class AppDelegate: UIResponder, UIApplicationDelegate, BuyBuddyInvalidTokenDelegate,BuyBuddyApiErrorDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        BuyBuddyApi.sharedInstance.sandBoxMode(isActive: true)
        BuyBuddyApi.sharedInstance.set(errorDelegate: self)
        BuyBuddyApi.sharedInstance.set(invalidTokenDelegate: self)
        BuyBuddyApi.sharedInstance.set(accessToken:"Eo6L4FCRRU+/tzIWEBlOYjOrewLxCkqjmPyYdbOH8h1p3vxcTrVNgJu+k430Ns1NKh5huFgjQse/b+tOIwDgJA==")

        return true
    }
    
    func BuyBuddyApiDidErrorReceived(_ errorCode: NSInteger, errorResponse: BuyBuddyBase?) {
        
        print(errorCode)
        if(errorResponse != nil){
            print(errorResponse!)
        }
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

