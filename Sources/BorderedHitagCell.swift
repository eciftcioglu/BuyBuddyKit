//
//  BorderedHitagCell.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import UIKit


class BorderedHitagCell:UICollectionViewCell{


    @IBOutlet private var imageView: CircleImageView!

    var shapeLayer = CAShapeLayer()
    var state:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
    }
    
    override func layoutSubviews() {
        self.drawBorder(shapeLayer: self.shapeLayer,inset:8)
        
    }
    
    public func setProductImage(image:UIImage){
        
        imageView.image = image
        
    }
}
