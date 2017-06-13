//
//  Animations.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import UIKit

var AssociatedObjectHandle: UInt8 = 0

extension UIView{
    
    var timer: Timer{
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as! Timer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func blink(duration:TimeInterval = 1){
        
        timer = Timer(timeInterval: duration, target: self, selector: #selector(UIView.blinkAnimate), userInfo: nil, repeats: true)
        //self.alpha = 0
        self.isHidden = false
        self.isUserInteractionEnabled = true
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    func blinkAnimate(){
        
        UIView.animate(withDuration: 1, delay:0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0
        }, completion: {finish in
            UIView.animate(withDuration: 0.5, delay:0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.alpha = 1.0
            }, completion: nil)
        })
    }
    
    func rotateRight(){
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        })
    }
    
    func rotateLeft(){
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) * 180.0)
        })
    }
    
    func fadeIn(duration: TimeInterval = 0.5){
        self.alpha = 0
        self.isHidden = false
        self.isUserInteractionEnabled = true
        UIView.animate(withDuration: duration, delay:0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut(duration: TimeInterval = 0.5){
        self.alpha = 1
        UIView.animate(withDuration: duration, delay:0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func scaleInOut(duration: TimeInterval){
        
        UIView.animate(withDuration: duration ,
                       animations: {
                        self.isHidden = false
                        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { finish in
                        UIView.animate(withDuration: duration, animations: {
                            self.transform = CGAffineTransform.identity
                        })
        })
    }
    
    func scaleIn(duration: TimeInterval){
        
        UIView.animate(withDuration: duration ,
                       animations: {
                        self.isUserInteractionEnabled = true
                        self.isHidden = false
                        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        },
                       completion: { finish in
                        UIView.animate(withDuration: duration, animations: {
                            self.transform = CGAffineTransform.identity
                        })
        })
    }
    
    func scaleOut(duration: TimeInterval){
        
        UIView.animate(withDuration: duration ,
                       animations: {
                        
        },
                       completion: { finish in
                        UIView.animate(withDuration: duration, animations: {
                            self.transform = CGAffineTransform(scaleX: 0, y: 0)
                            self.isUserInteractionEnabled = false
                            self.isHidden = true
                        })
        })
    }
}
