//
//  PopUpScanView.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 04/05/2017.
//
//

import Foundation
import UIKit

@IBDesignable
public class PopUpScanView : UIView {

    fileprivate var sizePriceView: UIView    = UIView(frame: .zero)
    fileprivate var centerImageView: UIImageView    = UIImageView(frame: .zero)
    fileprivate var overlayView: UIView    = UIView(frame:.zero)
    fileprivate let path = CGMutablePath()
    fileprivate let maskLayer = CAShapeLayer()
    
    @IBInspectable
        public var centerImage = UIImage(named: "Oval_2") {
        didSet {
            centerImageView.image = centerImage
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        createCenterImageView()
        createSizePriceView()
        createOverlayView()
        self.bringSubview(toFront: centerImageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        createCenterImageView()
        createSizePriceView()
        createOverlayView()
        self.bringSubview(toFront: centerImageView)
    }
    
    private func createSizePriceView(){
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.midX,y: self.frame.midY*0.7), radius: CGFloat(self.frame.width*0.4), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        sizePriceView.frame = CGRect(x:circlePath.bounds.minX, y: (self.frame.width*0.3)*0.5, width: self.frame.width*0.8, height: self.frame.width*0.3)
        sizePriceView.addblurView(radius: 20)
        sizePriceView.layer.cornerRadius = 20
        //sizePriceView.backgroundColor = UIColor.blue
        self.addSubview(sizePriceView)
    }
    
    private func createCenterImageView(){
        
        centerImageView.frame = CGRect(x:  self.frame.midX-self.frame.width*0.4, y: (self.frame.midY*0.7)-self.frame.width*0.4, width: self.frame.width*0.8, height: self.frame.width*0.8)
        centerImageView.layer.cornerRadius = self.centerImageView.layer.frame.width / 2
        centerImageView.image = centerImage
        centerImageView.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(centerImageView)
    }
    
    private func createOverlayView(){

        overlayView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        overlayView.alpha = 0.4
        overlayView.backgroundColor = UIColor.black
        self.insertSubview(overlayView, at: 1)
        
        path.addPath((UIBezierPath(arcCenter: CGPoint(x: self.frame.midX,y: self.frame.midY*0.7), radius: CGFloat(self.frame.width*0.4), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)).cgPath)
        path.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
    
    }
}





