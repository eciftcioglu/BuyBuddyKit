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
    
    
    public class  func callScannedProductView(viewController:UIViewController,transitionStyle:UIModalTransitionStyle = .crossDissolve,cartButton:BuyBuddyCartButton,hitagID:String?){
        if let vc = UIStoryboard(name: "BuyBuddyViews", bundle: Bundle(for: ScanViewController.self)).instantiateViewController(withIdentifier: "scannedProductView") as? ScanViewController
        {
            if (viewController.presentedViewController == nil ){
                if(checkDuplicate(id: hitagID!,view:viewController) == false){
                    showActivityIndicatory(uiView: viewController.view)
                    BuyBuddyApi.sharedInstance.getProductWith(hitagId:hitagID!, success: { (item: BuyBuddyObject<ItemData>, httpResponse) in
                        vc.product = item.data!
                        vc.userButton = cartButton
                        vc.hitagID = hitagID
                        vc.modalTransitionStyle = transitionStyle
                        vc.modalPresentationStyle = .overFullScreen
                        if(item.data != nil){
                            if (viewController.presentedViewController == nil){
                                for view in viewController.view.subviews{
                                    if let anim = view as? UIActivityIndicatorView{
                                        anim.stopAnimating()
                                    }
                                }
                                viewController.present(vc, animated: true, completion: nil)
                            }
                        }
                        
                        //popUpScanView.centerImage = self.product.image_url
                        //popUpScanView.setSizePrice(size: product.size!, price:product.price!)
                        
                    }) { (err, httpResponse) in
                    }
                }
            }
        }
    }
    
    public class  func callShoppingBasketView(viewController:UIViewController,transitionStyle:UIModalTransitionStyle = .crossDissolve,cartButton:BuyBuddyCartButton){
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
    
    public class  func callPaymentFinalizerView(viewController:UIViewController,transitionStyle:UIModalTransitionStyle = .crossDissolve,orderId:Int?){
        if let vc = UIStoryboard(name: "BuyBuddyViews", bundle: Bundle(for: FinalizePaymentViewController.self)).instantiateViewController(withIdentifier: "paymentFinalizerView") as? FinalizePaymentViewController
        {
            vc.modalTransitionStyle = transitionStyle
            vc.modalPresentationStyle = .overFullScreen
    
            
            if (viewController.presentedViewController == nil){
                BuyBuddyApi.sharedInstance.getOrderDetail(saleId: orderId!, success: { (item:BuyBuddyObject<OrderDetail>, httpResponse) in
                    
                    if let data = item.data{
                        vc.orderDetails = data
                    }
                    viewController.present(vc, animated: true, completion: nil)
                    
                }, error: { (err, httpResponse) in
                    
                })
            }
            
        }
    }

    private class func showActivityIndicatory(uiView: UIView) {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x:uiView.frame.width/2, y:uiView.frame.height/2, width:40.0, height:40.0)
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
    
    private class func checkDuplicate(id:String,view:UIViewController)->Bool{
        
        for (key,_) in ShoppingBasketManager.shared.basket{
            
            if(key == id){
                DispatchQueue.main.async {
                    
                    let acceptAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default) { (_) -> Void in
                        view.dismiss(animated: true, completion: nil)
                    }
                    let alertController = UIAlertController(title: "Uyarı!", message:"Aynı Hitag birden fazla kez eklenememektedir.Başka bir hitag okutunuz.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(acceptAction)
                    view.present(alertController, animated: true, completion: nil)
                }
                return true
            }
        }
        return false
    }
}


