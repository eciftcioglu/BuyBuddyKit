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

@IBDesignable
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
        createLabel()
        NotificationCenter.default.addObserver(self, selector: #selector(ShoppingCartButton.countDidChange(_:)), name: NSNotification.Name(rawValue: ShoppingBasketNotification), object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createLabel(){
        countLabel.frame = CGRect(x:  0, y: 0, width: 23, height: 23)
        countLabel.layer.cornerRadius = self.countLabel.layer.frame.width / 2
        self.addSubview(countLabel)

    }
 
    public func countDidChange(_ notification: Notification){
        countLabel.text = notification.userInfo?["count"] as? String
    }
}
