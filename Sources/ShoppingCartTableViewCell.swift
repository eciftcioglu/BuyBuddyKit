//
//  ShoppingCartTableViewCell.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 09/05/2017.
//
//

import Foundation
import UIKit



class ShoppingCartTableViewCell:UITableViewCell{

    @IBOutlet private var productImage: CircleImageView!
    @IBOutlet private var productName: UILabel!
    @IBOutlet private var productSize: UILabel!
    @IBOutlet private var productColor: CircleImageView!
    @IBOutlet private var productPrice: UILabel!


    
    public func setData(data:ItemData){
    
        setProductName(name: data.code!)
        setProductColor(color: data.color!)
        setProductSize(size:  data.size!)
        setProductImage(image: data.image!)
        setProductPrice(price: data.price!)

    }
    private func setProductImage(image:UIImage){
        
        productImage.image = image

    }
    private func setProductName(name:String){
        
        productName.text = name
    }
    private func setProductSize(size:String){
        
        productSize.text = size
        
    }
    private func setProductColor(color:UIColor){
        
        productColor.backgroundColor = color
    }
    
    private func setProductPrice(price:Double){
        
        productPrice.text = String(price)
    }
}
