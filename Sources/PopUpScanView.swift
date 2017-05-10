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

    fileprivate var sizePriceView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    fileprivate var centerImageView: UIImageView    = UIImageView(frame: .zero)
    fileprivate var overlayView: UIView    = UIView(frame:.zero)
    fileprivate var sizeLabel: UILabel = UILabel(frame: .zero)
    fileprivate var priceLabel: UILabel = UILabel(frame: .zero)
    fileprivate let path = CGMutablePath()
    fileprivate let maskLayer = CAShapeLayer()
    fileprivate let strokeLayer = CAShapeLayer()

    
        public var centerImage = UIImage(named: "Oval_2") {
        didSet {
            centerImageView.image = centerImage
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        createCenterImageView()
        createSizePriceView()
        createOverlayView()
        createStroke()
        createLabels()
        self.bringSubview(toFront: centerImageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear
        createCenterImageView()
        createSizePriceView()
        createOverlayView()
        createStroke()
        createLabels()
        self.bringSubview(toFront: centerImageView)
    }
    
    private func createLabels(){
        sizeLabel.frame = CGRect(x:  8, y: 8, width: 40, height: 22)
        priceLabel.frame = CGRect(x:  sizePriceView.frame.width-108, y: 8, width: 100, height: 22)
        sizeLabel.font = UIFont(name: "Avenir-Medium", size: 16)
        priceLabel.font = UIFont(name: "Avenir-Medium", size: 16)
        sizeLabel.textColor = UIColor.white
        priceLabel.textColor = UIColor.white

        sizeLabel.textAlignment = .left
        priceLabel.textAlignment = .right

        sizeLabel.text = "M"
        priceLabel.text = "99 TL"
        sizePriceView.addSubview(sizeLabel)
        sizePriceView.addSubview(priceLabel)

    }
    private func createSizePriceView(){
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.midX,y: self.frame.midY*0.7), radius: CGFloat(self.frame.width*0.4), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        sizePriceView.frame = CGRect(x:circlePath.bounds.minX, y: (self.frame.width*0.3)*0.5, width: self.frame.width*0.8, height: self.frame.width*0.3)
        sizePriceView.layer.cornerRadius = 20
        sizePriceView.clipsToBounds = true
        sizePriceView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(sizePriceView)
    }
    
    private func createCenterImageView(){
        
        centerImageView.frame = CGRect(x:  self.frame.midX-self.frame.width*0.4, y: (self.frame.midY*0.7)-self.frame.width*0.4, width: self.frame.width*0.8, height: self.frame.width*0.8)
        centerImageView.layer.cornerRadius = self.centerImageView.layer.frame.width / 2
        centerImageView.image = centerImage
        centerImageView.contentMode = UIViewContentMode.scaleAspectFill
        centerImageView.image = UIImage(named: "Oval_2", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.addSubview(centerImageView)
    }
    
    private func createStroke(width:CGFloat = 3.0){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.midX,y: self.frame.midY*0.7), radius: CGFloat(self.frame.width*0.4), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        strokeLayer.path = circlePath.cgPath
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.strokeColor = UIColor.white.cgColor
        strokeLayer.lineWidth = width
        self.layer.addSublayer(strokeLayer)
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





