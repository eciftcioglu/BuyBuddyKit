//
//  ShoppingCartButton.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 05/05/2017.
//
//

import Foundation
import UIKit


let ShoppingBasketNotification = "ShoppingBasketNotification"

class ShoppingCartButton:UIButton{
    
    fileprivate var countLabel: UILabel = UILabel(frame: .zero)

    
    @IBInspectable
    public var buttonImage = UIImage(named: "shopping_cart") {
        didSet {
            self.setImage(buttonImage, for: UIControlState.normal) 
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(ShoppingCartButton.countDidChange(_:)), name: NSNotification.Name(rawValue: ShoppingBasketNotification), object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    public func countDidChange(_ notification: Notification){
        countLabel.text = notification.userInfo?["count"] as? String

    }
}
