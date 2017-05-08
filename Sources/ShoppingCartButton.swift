//
//  ShoppingCartButton.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 05/05/2017.
//
//

import Foundation
import UIKit



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
        self.setImage(UIImage(named: "shopping_cart"), for: UIControlState.normal)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createLabel()
        self.setImage(UIImage(named: "shopping_cart"), for: UIControlState.normal)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createLabel(){
        countLabel.frame = CGRect(x:  0, y: 0, width: 23, height: 23)
        countLabel.layer.cornerRadius = self.countLabel.layer.frame.width / 2
        self.addSubview(countLabel)
    }
 

    
}

