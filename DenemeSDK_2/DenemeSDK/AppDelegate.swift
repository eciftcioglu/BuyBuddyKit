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
        // Override point for customization after application launch.
        
        //Call this method to start monitoring and ranging for hitag devices
        BuyBuddyHitagManager.startHitagManager()
        
        //Set to true to enable sandbox mode.Default is false
        
        BuyBuddyApi.sharedInstance.sandBoxMode(isActive: true)
        
        BuyBuddyApi.sharedInstance.set(errorDelegate: self)
        BuyBuddyApi.sharedInstance.set(invalidTokenDelegate: self)
        BuyBuddyApi.sharedInstance.set(accessToken: "EGts2QfOQAW5nhQL29tLHad8PUA6gUiykKaZQ9kXfWsIO+AnuaRHYLHQAP3IoNVBx5J3uMf4QFqomeMgjHtEZA==")
        
        return true
    }
    
    func BuyBuddyApiDidErrorReceived(_ errorCode: NSInteger, errorResponse: HTTPURLResponse) {
        
        print(errorCode)
        print(errorResponse)
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

