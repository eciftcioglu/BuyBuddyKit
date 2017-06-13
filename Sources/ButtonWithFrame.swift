//
//  ButtonWithFrame.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 12/05/2017.
//
//

import Foundation
import UIKit

@IBDesignable
class ButtonWithFrame : UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 1.0, alpha: 1).cgColor
        self.layer.cornerRadius = 2
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 1.0, alpha: 1).cgColor
        self.layer.cornerRadius = 2
    }
    
    
}
