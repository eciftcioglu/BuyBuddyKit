//
//  ViewController.swift
//  DenemeSDK
//
//  Created by Emir Çiftçioğlu on 08/05/2017.
//  Copyright © 2017 BuyBuddy. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import BuyBuddyKit


class ViewController: RSCodeReaderViewController,BuyBuddyCartButtonDelegate,BuyBuddyOrderCreatedDelegate{
    

    @IBOutlet var frame: UIView!
    @IBOutlet var cartButton: BuyBuddyCartButton!

    var orderID:Int?
    var basketTotal:Float?
    override func viewDidLoad() {
        super.viewDidLoad()

        cartButton.delegate = self
        
        BuyBuddyApi.sharedInstance.set(orderDelegate: self)
        
        //Bluetooth beacon scan
        frame.layer.addCustomBorder(rightEdge:true ,leftEdge:true,topEdge:true,bottomEdge:true,color: UIColor.purple, thickness: 3)
        
        self.output.rectOfInterest = CGRect(x: 0, y: 0, width:0.7, height:1 )
        self.focusMarkLayer.strokeColor = UIColor.clear.cgColor
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                DispatchQueue.main.async(execute:{
                    
                    if let validHitagId = BuyBuddyHitagValidator.isValidPatternForHitag(hitagId: barcode.stringValue) {
                        BuyBuddyViewManager.callScannedProductView(viewController: self, cartButton: self.cartButton, hitagID: validHitagId)
                    }else {
                    print("error")
                    }
                    
                })
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! PayVC
        detailVC.orderId = orderID
        detailVC.basketTotal = basketTotal
    }
    
    func BuyBuddyOrderCreated(orderId: Int, basketTotal: Float) {
        
        orderID = orderId
        self.basketTotal = basketTotal
        performSegue(withIdentifier: "payThis", sender: self)
    }
    
    func buttonWasPressed(_ button: UIButton) {
        BuyBuddyViewManager.callShoppingBasketView(viewController: self,transitionStyle:.crossDissolve,cartButton:self.cartButton )
        
    }

}
extension CALayer{

    
    func addCustomBorder(rightEdge: Bool = false,leftEdge:Bool = false,topEdge:Bool = false,bottomEdge:Bool = false, color: UIColor, thickness: CGFloat,clip:CGFloat=0) {
        
        let borderRight = CALayer()
        let borderLeft = CALayer()
        let borderTop = CALayer()
        let borderBottom = CALayer()
        
        if (rightEdge){
            borderRight.frame = CGRect(x:self.frame.width - thickness, y:0, width:thickness, height:self.frame.height)
            borderRight.backgroundColor = color.cgColor;
            self.addSublayer(borderRight)
        }
        
        if(leftEdge){
            borderLeft.frame = CGRect(x:0, y:0, width:thickness, height:self.frame.height)
            borderLeft.backgroundColor = color.cgColor;
            self.addSublayer(borderLeft)
        }
        
        if(topEdge){
            borderTop.frame = CGRect(x:0, y:0, width:self.frame.width, height:thickness)
            borderTop.backgroundColor = color.cgColor;
            self.addSublayer(borderTop)
        }
        
        if(bottomEdge){
            borderBottom.frame = CGRect(x:0+clip, y:self.frame.height - thickness, width:self.frame.width-(2*clip), height:thickness)
            borderBottom.backgroundColor = color.cgColor;
            self.addSublayer(borderBottom)
        }
    }


}
