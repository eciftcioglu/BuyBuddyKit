//
//  testfunc.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//
//

import Foundation
import UIKit


public let orderServiceNotification = "orderServiceNotification"

public class BuyBuddyViewManager{
    
    public class  func callScannedProductView(viewController:UIViewController,transitionStyle:UIModalTransitionStyle = .crossDissolve,cartButton:ShoppingCartButton,hitagID:String?){
        if let vc = UIStoryboard(name: "BuyBuddyViews", bundle: Bundle(for: ScanViewController.self)).instantiateViewController(withIdentifier: "scannedProductView") as? ScanViewController
        {
            vc.userButton = cartButton
            vc.hitagID = hitagID
            vc.modalTransitionStyle = transitionStyle
            vc.modalPresentationStyle = .overFullScreen
            
            if (viewController.presentedViewController == nil ){
                viewController.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    public class  func callShoppingBasketView(viewController:UIViewController,transitionStyle:UIModalTransitionStyle = .crossDissolve,cartButton:ShoppingCartButton){
        if let vc = UIStoryboard(name: "BuyBuddyViews", bundle: Bundle(for: ShoppingBasketViewController.self)).instantiateViewController(withIdentifier: "shoppingBasketView") as? ShoppingBasketViewController
        {
            vc.modalTransitionStyle = transitionStyle
            vc.modalPresentationStyle = .overFullScreen
            vc.userButton = cartButton
            
            if (viewController.presentedViewController == nil){
                viewController.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    public class  func callPaymentFinalizerView(viewController:UIViewController,transitionStyle:UIModalTransitionStyle = .crossDissolve,orderId:Int?,orderTotal:Float?){
        if let vc = UIStoryboard(name: "BuyBuddyViews", bundle: Bundle(for: FinalizePaymentViewController.self)).instantiateViewController(withIdentifier: "paymentFinalizerView") as? FinalizePaymentViewController
        {
            vc.modalTransitionStyle = transitionStyle
            vc.modalPresentationStyle = .overFullScreen
            vc.orderId = orderId
            vc.orderTotal = orderTotal
            if (viewController.presentedViewController == nil){
                viewController.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    static func sendCreateOrderNotification(_ isOrderCreated: OrderDelegateResponse) {
        
        let connectionDetails:[String:Any] = ["sale_id": isOrderCreated.sale_id!, "grand_total": isOrderCreated.grand_total!]
        NotificationCenter.default.post(name: Notification.Name(rawValue: orderServiceNotification), object: self, userInfo: connectionDetails)
    }
}


