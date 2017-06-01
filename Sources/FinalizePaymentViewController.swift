//
//  FinalizePaymentViewController.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import UIKit


class FinalizePaymentViewController:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BluetoothAlertDelegate,BluetoothConnectionDelegate{
    @IBOutlet var paymentLabel: UILabel!
    @IBOutlet var midView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var completionView: UIView!
    @IBOutlet var topInfoLabel: UILabel!
    
    var orderId:Int?
    var state = false
    var hitagIds: [String] = []
    var blemanager : BuyBuddyBLEManager?
    var hitagValidations: [String : Int] = [:]
    var hitags: [String : String] = [:]
    var hitagsTried      : [String : Int] = [:]

    var devicesToOpen: Set<String> = []
    var openedDevices: Set<String> = []
    var devicesWithConnectionError: Set<String> = []
    var indexCheck:[Int] = []

    var currentHitag: String = ""
    var errors:String = ""

    fileprivate let sectionInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBlurEffect(dark: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BorderedHitagCell", bundle:Bundle(for: type(of: self))), forCellWithReuseIdentifier: "BorderedHitagCell")
   
        midView.blink(duration:1.5)
        
        for hitag in hitagIds {
            devicesToOpen.insert(hitag)
            hitagsTried[hitag] = 0
        }
  

        self.currentHitag = self.devicesToOpen.first!
        self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag,viewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        completionView.alpha = 0

    }
    
    @IBAction func dismissPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func connectionTimeOut(hitagId: String) {
        
        
            if (hitagsTried[hitagId]! < 3){
                hitagsTried[hitagId] = 1 + hitagsTried[hitagId]!
                let change = self.devicesToOpen.popFirst()
                devicesToOpen.insert(change!)
                currentHitag = devicesToOpen.first!
                self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag,viewController: self)
            }else{
                if(!devicesWithConnectionError.contains(hitagId)){
                    devicesWithConnectionError.insert(hitagId)
                    devicesToOpen.remove(hitagId)
                }
                if(devicesToOpen.count == 0){
                    completionCheck()
                }
            }
        }
    
    
    func connectionComplete(hitagId: String, validateId: Int) {

        
        BuyBuddyApi.sharedInstance.validateOrder(orderId: self.orderId!, hitagValidations: [hitagId : validateId], success: { (orderResponse, httpResponse) in
            
            self.hitags = orderResponse.data!.hitag_passkeys!
            if (self.blemanager?.bleHandler.sendPassword(password: self.hitags[hitagId]!))! {
            }
            
        }, error: { (err, httpResponse) in
            
        })
        
    }
    
    func devicePasswordSent(dataSent: Bool, hitagId: String, responseCode: Int) {
        
        if(dataSent == false && responseCode == 0){
            devicesToOpen.remove(self.currentHitag)
            if(!devicesWithConnectionError.contains(hitagId)){
                devicesWithConnectionError.insert(hitagId)
            }
        }
        if dataSent {
            self.openedDevices.insert(hitagId)
            self.devicesToOpen.remove(hitagId)
            if self.devicesToOpen.count > 0 {
                if let device = self.devicesToOpen.first{
                    self.currentHitag = device
                    if self.blemanager!.bleHandler.disconnectFromHitag() {
                        self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag,viewController: self)
                    }
                }
                
            }else{
                //FINISH !!!
                completionCheck()
            }
            
            BuyBuddyApi.sharedInstance.completeOrder(orderId: self.orderId!, compileId: hitagId, success: { (HitagValidationResponse, httpResponse) in
                
            }) { (err, httpResponse) in
                
            }
        }
        
    }
  
    func completionCheck(){
        
        let acceptAction = UIAlertAction(title: "Tekrar Dene", style: UIAlertActionStyle.default) { (_) -> Void in
            self.state = false
            for hitag in self.devicesWithConnectionError {
                self.devicesToOpen.insert(hitag)
                self.hitagsTried[hitag] = 0
            }
            self.devicesWithConnectionError.removeAll()
            self.currentHitag = self.devicesToOpen.first!
            self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag,viewController: self)
        }
        
        let cancelAction = UIAlertAction(title: "Iptal", style: UIAlertActionStyle.cancel) {(_) -> Void in
            _ = self.blemanager!.bleHandler.disconnectFromHitag()
            self.midView.timer.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.topInfoLabel.text = "Ödeme Hatası!"
                self.completionView.fadeIn(duration: 0.5)
                self.state = true
                self.midView.fadeOut()
                self.collectionView.reloadData()
            }
        }
        
        if(devicesWithConnectionError.count == 0){
        _ = self.blemanager!.bleHandler.disconnectFromHitag()
        self.midView.timer.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.topInfoLabel.text = "Ödeme Tamamlandı"
            self.completionView.fadeIn(duration: 0.5)
            self.state = true
            self.midView.fadeOut()
            self.collectionView.reloadData()
            }
        
        }else{
            
        _ = self.blemanager!.bleHandler.disconnectFromHitag()
        DispatchQueue.main.async {
            for device in self.devicesWithConnectionError{
                self.errors += device+" "
            }
            let alertController = UIAlertController(title: "Uyarı!", message:"Cihazla ilgili bir sorundan dolayı "+self.errors+"numaralı cihanız açılamamıştır.Tekrar Denemek için tuşa basınız.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(acceptAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func stateChange() {
        
        
    }
}
extension FinalizePaymentViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hitagIds.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.height-16,height:collectionView.frame.height-16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BorderedHitagCell", for: indexPath) as! BorderedHitagCell
        cell.state = state
        if(cell.state == true){
            cell.setProductImage(image: UIImage(named: "Oval_2", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
            
            DispatchQueue.main.async {
                cell.shapeLayer.strokeColor = UIColor(red: 0x12/255,green: 0xc3/255,blue: 0x9f/255,alpha: 1.0).cgColor
                cell.timer.invalidate()
            }
        }else {
            DispatchQueue.main.async {
                cell.shapeLayer.strokeColor = UIColor.clear.cgColor
                cell.blink(duration:1.5)
            }
            cell.setProductImage(image: UIImage(named: "buddyLogo", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
        }
        //let data = filltable[(indexPath as NSIndexPath).row]
        return cell
    }
}

