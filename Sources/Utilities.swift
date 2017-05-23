//
//  Utilities.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 09/05/2017.
//
//

import Foundation
import UIKit

class Utilities{
    
    private static func getUdKey(_ udKey: String) -> String {
        return "co.buybuddy.userdefaults_" + udKey
    }
    
    public static func saveToUd(key: String, value: Any){
        UserDefaults.standard.set(value, forKey: getUdKey(key))
        UserDefaults.standard.synchronize()
    }
    
    public static func getFromUd(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: getUdKey(key)) ?? nil
    }
    
    class func dataFrom(hex: String) -> Data {
        var hex = hex
        var data = Data()
        while(hex.characters.count > 0) {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
    
    public class func showError(viewController:UIViewController,message:String){
        
        DispatchQueue.main.async {
            
            let acceptAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default) { (_) -> Void in
                viewController.dismiss(animated: true, completion: nil)
            }
            let alertController = UIAlertController(title: "Uyarı!", message:message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(acceptAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
        
    }
}
