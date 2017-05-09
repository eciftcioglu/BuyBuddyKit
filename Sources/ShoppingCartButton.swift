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
    fileprivate var button: UIButton = UIButton(frame: .zero)

    var delegate:ShoppingCartButtonDelegate?
    
    @IBInspectable
    public var buttonImage = UIImage(named: "shopping_cart") {
        didSet {
            self.setImage(buttonImage, for: UIControlState.normal) 
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createLabel()
        createButton()
        self.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        self.setImage(UIImage(named: "shopping_cart"), for: UIControlState.normal)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createLabel()
        createButton()
        self.setImage(UIImage(named: "shopping_cart"), for: UIControlState.normal)
    }
    
    private func createButton(){
        button.frame = CGRect(x:  UIScreen.main.bounds.width-UIScreen.main.bounds.width/5, y: 0, width:UIScreen.main.bounds.width/5, height:UIScreen.main.bounds.width/5)
        

        self.addSubview(countLabel)
    }
    
    private func createLabel(){
        countLabel.frame = CGRect(x:  self.frame.width-23, y: 0, width: 23, height: 23)
        countLabel.textAlignment = .center
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

