//
//  CircleButton.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import UIKit

class CircleButton : UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.layer.frame.width / 2
        self.layer.masksToBounds = true
        self.isEnabled = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.adjustImageAndTitleOffsets()
        self.addBlurEffect()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
    func adjustImageAndTitleOffsets () {
        
        let spacing: CGFloat = 3.0
        let imageSize = self.imageView!.frame.size
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(imageSize.height + spacing), 0)
        let titleSize = self.titleLabel!.frame.size
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
    }
}
