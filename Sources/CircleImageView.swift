//
//  CircleImageView.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 09/05/2017.
//
//

import Foundation
import UIKit

class CircleImageView: UIImageView {
    let shapeLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.layer.frame.width / 2
        self.layer.masksToBounds = true
    }
}
