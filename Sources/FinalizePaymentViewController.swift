//
//  FinalizePaymentViewController.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import UIKit


class FinalizePaymentViewController:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,BluetoothAlertDelegate{
    @IBOutlet var paymentLabel: UILabel!
    @IBOutlet var midView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var completionView: UIView!
    
    var orderId:Int?
    var state = false
    var hitagIds: [String] = []
    var blemanager : BuyBuddyBLEManager?
    var hitagValidations: [String : Int] = [:]
    var hitags: [String : String] = [:]
    
    var devicesToOpen: Set<String> = []
    var openedDevices: Set<String> = []
    var currentHitag: String = ""
    

    fileprivate let sectionInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBlurEffect(dark: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BorderedHitagCell", bundle:Bundle(for: type(of: self))), forCellWithReuseIdentifier: "BorderedHitagCell")
        NotificationCenter.default.addObserver(self, selector: #selector(FinalizePaymentViewController.didOpen(_:)), name: NSNotification.Name(rawValue: BLEServiceChangedStatusNotification), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(FinalizePaymentViewController.didConnect(_:)), name: NSNotification.Name(rawValue: BLEServiceConnectionNotification), object: nil)
        midView.blink(duration:1.5)
        
        for hitag in hitagIds {
            devicesToOpen.insert(hitag)
        }
        
        if let validations = BuyBuddyHitagManager.getValidNumbersWith(hitagIds: self.hitagIds) {
            self.hitagValidations = validations
            
            self.currentHitag = self.devicesToOpen.first!
            self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        completionView.alpha = 0
    }
    
    @IBAction func dismissPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BLEServiceChangedStatusNotification), object: nil)
    }
    
    
    func didConnect(_ notification: Notification){
        
        let id =  notification.userInfo?["hitagId"] as! String
        
        BuyBuddyApi.sharedInstance.completeOrder(orderId: self.orderId!, hitagValidations: [id : hitagValidations[id]!], success: { (orderResponse, httpResponse) in
            
            self.hitags = orderResponse.data!.hitag_passkeys!
            if (self.blemanager?.bleHandler.sendPassword(password: self.hitags[id]!))! {
                print("Password Send Successfull")
            }
            
        }, error: { (err, httpResponse) in
            
        })
        
        
        /*BuyBuddyApi.sharedInstance.createHitagCompletion(orderId: orderId!, compileId: id, success: { (HitagValidationResponse, httpResponse) in
            
        }) { (err, httpResponse) in
            
        }*/
}
    
    
    
    func didOpen(_ notification: Notification){
        
        let check = notification.userInfo?["isConnected"] as! Bool
        let id =  notification.userInfo?["hitagId"] as! String
        let statusCode = notification.userInfo?["responseCode"] as! Int
        
        print(statusCode)
        
        if check {
            self.openedDevices.insert(self.currentHitag)
            self.devicesToOpen.remove(self.currentHitag)
            if self.devicesToOpen.count > 0 {
                self.currentHitag = self.devicesToOpen.first!
                if self.blemanager!.bleHandler.disconnectFromHitag() {
                    self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag)
                }
                
            }else{
                //FINISH !!!
                
                DispatchQueue.main.async {
                    self.paymentLabel.text = "Ödeme Tamamlandı"
                    self.midView.timer.invalidate()
                    self.completionView.fadeIn(duration: 0.5)
                    self.state = true
                    DispatchQueue.main.async {
                        self.midView.fadeOut()
                    }
                    self.collectionView.reloadData()
                }
            }
        
            BuyBuddyApi.sharedInstance.updateHitagCompletion(orderId: self.orderId!, compileId: id, success: { (HitagValidationResponse, httpResponse) in
                print(HitagValidationResponse)
                
            }) { (err, httpResponse) in
                
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
            }
        }else {
            DispatchQueue.main.async {
                cell.shapeLayer.strokeColor = UIColor.clear.cgColor
            }
            cell.setProductImage(image: UIImage(named: "buddyLogo", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
        }
        //let data = filltable[(indexPath as NSIndexPath).row]
        return cell
    }
}

