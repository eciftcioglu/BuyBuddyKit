//
//  View.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 05/05/2017.
//
//

import Foundation
import UIKit


extension UIView{

    func addblurView(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, at: 0)
    }
    func addBlurEffect(animation:Bool = false) {
        
        self.backgroundColor = UIColor(patternImage: imageWithColor(UIColor.clear))
        let frost = UIVisualEffectView()
        frost.frame = (self.bounds)
        frost.isUserInteractionEnabled = false
        frost.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(frost, at: 0)
        if (animation == true){
            UIView.animate(withDuration: 0.5) {
                frost.effect = UIBlurEffect(style: .light)
            }
        }
        else{
            frost.effect = UIBlurEffect(style: .light)
        }
    }
    func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func roundedTopCorner(){
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight ], cornerRadii: CGSize(width: 5, height:10)).cgPath
        self.layer.mask = rectShape
    }
    
    func roundedBottomCorner(){
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .bottomRight ], cornerRadii: CGSize(width: 5, height:10)).cgPath
        self.layer.mask = rectShape
    }
}
