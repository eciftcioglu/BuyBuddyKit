//
//  testfunc.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//
//

import Foundation
import UIKit

public class BuyBuddyViewManager{
    
    public class  func callScannedProductView(param:UIViewController){
         if let vc = UIStoryboard(name: "BuyBuddyViews", bundle: Bundle(for: ScanViewController.self)).instantiateViewController(withIdentifier: "scannedProductView") as? ScanViewController
         {
         param.modalTransitionStyle = .crossDissolve
         param.modalPresentationStyle = .overCurrentContext
         param.present(vc, animated: true, completion: nil)
         }
     }
    
    public class  func callPaymentFinalizerView(param:UIViewController){
        if let vc = UIStoryboard(name: "BuyBuddyViews", bundle: Bundle(for: FinalizePaymentViewController.self)).instantiateViewController(withIdentifier: "paymentFinalizerView") as? FinalizePaymentViewController
        {
            param.modalTransitionStyle = .crossDissolve
            param.modalPresentationStyle = .overCurrentContext
            param.present(vc, animated: true, completion: nil)
        }
    }
}


