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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BuyBuddyHitagManager.startHitagManager()

        return true
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

