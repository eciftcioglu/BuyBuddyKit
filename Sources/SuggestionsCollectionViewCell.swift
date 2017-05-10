//
//  SuggestionsCollectionViewCell.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 09/05/2017.
//
//

import Foundation
import UIKit

class SuggestionsCollectionViewCell:UICollectionViewCell{

    @IBOutlet private var productImage: CircleImageView!
    @IBOutlet private var productPrice: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask.insert(.flexibleHeight)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
    }
    
    public func setProductImage(image:UIImage){
        
        productImage.image = image
        
    }
    
    public func setProductPrice(price:Float){
        
        productPrice.text = String(price)
    }
}
