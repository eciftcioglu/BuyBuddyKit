//
//  ShoppingCartButton.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import UIKit

public protocol ShoppingCartButtonDelegate:class {
    func buttonWasPressed(_ button:UIButton)
}

@IBDesignable
public class ShoppingCartButton:UIButton,ShoppingCartDelegate{
    
    fileprivate var countLabel: UILabel = UILabel(frame: .zero)
    public weak var delegate:ShoppingCartButtonDelegate?
    fileprivate var blurCheck:Bool = true
    
    @IBInspectable
    public var buttonImage = UIImage(named: "shopping_cart", in: Bundle(identifier:"BB.BuyBuddyKit-iOS"), compatibleWith: nil) {
        didSet {
            self.setImage(buttonImage, for: UIControlState.normal)
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.adjustImageAndTitleOffsets()
        self.addBlurEffect()
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        createLabel()
        self.layer.cornerRadius = self.layer.frame.width / 2
        self.layer.masksToBounds = true
        self.setImage(UIImage(named: "shopping_cart", in: Bundle(for: type(of: self)), compatibleWith: nil), for: UIControlState.normal)
    }
    
    private func createLabel(){
        countLabel.frame = CGRect(x:   self.frame.width/2, y:  self.frame.width/2, width: self.frame.width/3.5, height: self.frame.width/3.5)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.buddyGreen()
        countLabel.textColor = UIColor.white
        countLabel.layer.masksToBounds = true
        countLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        countLabel.layer.cornerRadius = countLabel.layer.frame.width / 2
        
        self.addSubview(countLabel)
    }
    
    func buttonPress(button:UIButton) {
        delegate?.buttonWasPressed(self)
    }
    
    public func removeBlur(){
        
        let subViews = self.subviews
        for subview in subViews{
            if subview.tag == 100 && blurCheck == true{
                blurCheck = false
                subview.removeFromSuperview()
            }
        }
    }
    
    public func addblur(){
    
        if (blurCheck == false){
            self.addBlurEffect()
        }
    }
    
    public func countDidChange(_ data: String) {
        countLabel.text = data
    }
    
    func adjustImageAndTitleOffsets () {
        
        let spacing: CGFloat = 3.0
        let imageSize = self.imageView!.frame.size
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(imageSize.height + spacing), 0)
        let titleSize = self.titleLabel!.frame.size
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
    }
    
}
