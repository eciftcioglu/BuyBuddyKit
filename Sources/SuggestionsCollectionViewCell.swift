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

    
    public func setProductImage(image:UIImage){
        
        productImage.image = image
        
    }
    
    public func setProductPrice(price:Double){
        
        productPrice.text = String(price)
    }
}
