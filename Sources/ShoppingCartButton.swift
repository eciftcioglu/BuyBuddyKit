//
//  ShoppingCartButton.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 05/05/2017.
//
//

import Foundation
import UIKit

protocol ShoppingCartButtonDelegate {
    func buttonWasPressed(_ button:UIButton)
}


class ShoppingCartButton:UIButton,ShoppingCartDelegate{
    
    fileprivate var countLabel: UILabel = UILabel(frame: .zero)

    var delegate:ShoppingCartButtonDelegate?
    
    @IBInspectable
    public var buttonImage = UIImage(named: "shopping_cart", in: Bundle(for: type(of: self) as! AnyClass), compatibleWith: nil) {
        didSet {
            self.setImage(buttonImage, for: UIControlState.normal) 
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createLabel()
        self.setImage(UIImage(named: "shopping_cart", in: Bundle(for: type(of: self)), compatibleWith: nil), for: UIControlState.normal)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createLabel()
        self.setImage(UIImage(named: "shopping_cart", in: Bundle(for: type(of: self)), compatibleWith: nil), for: UIControlState.normal)
    }
    
    private func createLabel(){
        countLabel.frame = CGRect(x:  self.frame.width-23, y: 0, width: 23, height: 23)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.buddyGreen()
        countLabel.layer.cornerRadius = self.countLabel.layer.frame.width / 2
        self.addSubview(countLabel)
    }
    
    func buttonPress(button:UIButton) {
        delegate?.buttonWasPressed(self)
    }
    func countDidChange(_ data: String) {
        countLabel.text = data
    }
 
}

