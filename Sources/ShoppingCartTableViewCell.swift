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
    
        if(data.code != nil){
            setProductName(name: data.code!)}
        if(data.color != nil){
            
            setProductColor(color: data.color!)}
        if(data.size != nil){
            
            setProductSize(size:  data.size!)}
        if(data.image_url != nil){
            //setProductImage(image: data.image_url!)
        }
        if(data.price != nil){
            
            setProductPrice(price: data.price!.current_price!)}
        

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
    
    private func setProductPrice(price:Float){
        
        productPrice.text = String(price) + " TL"
    }
}
