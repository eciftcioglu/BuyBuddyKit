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
    var hitagsTried      : [String : Int] = [:]

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
        NotificationCenter.default.addObserver(self, selector: #selector(FinalizePaymentViewController.didReceiveData(_:)), name: NSNotification.Name(rawValue: BLEServiceChangedStatusNotification), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(FinalizePaymentViewController.didConnect(_:)), name: NSNotification.Name(rawValue: BLEServiceConnectionNotification), object: nil)
        midView.blink(duration:1.5)
        
        for hitag in hitagIds {
            devicesToOpen.insert(hitag)
            hitagsTried[hitag] = 0
        }
  
        if let validations = BuyBuddyHitagManager.getValidNumbersWith(hitagIds: self.hitagIds) {
            self.hitagValidations = validations
            self.currentHitag = self.devicesToOpen.first!
            self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag)
        }else {
            print("Validations error")
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
        
        print(id + " CONNECTED")
        
        BuyBuddyApi.sharedInstance.validateOrder(orderId: self.orderId!, hitagValidations: [id : hitagValidations[id]!], success: { (orderResponse, httpResponse) in
            
            self.hitags = orderResponse.data!.hitag_passkeys!
            if (self.blemanager?.bleHandler.sendPassword(password: self.hitags[id]!))! {
            }
            
        }, error: { (err, httpResponse) in
            
        })
}
    
    func didReceiveData(_ notification: Notification){
        
        let check = notification.userInfo?["isConnected"] as! Bool
        let id =  notification.userInfo?["hitagId"] as! String
        let statusCode = notification.userInfo?["responseCode"] as! Int
        
        if check {
            self.openedDevices.insert(self.currentHitag)
            self.devicesToOpen.remove(self.currentHitag)
            if self.devicesToOpen.count > 0 {
                if let device = self.devicesToOpen.first{
                self.currentHitag = device
                    if self.blemanager!.bleHandler.disconnectFromHitag() {
                    self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag)
                    }
                }
                
            }else{
                //FINISH !!!
                _ = self.blemanager!.bleHandler.disconnectFromHitag()
                self.midView.timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.paymentLabel.text = "Ödeme Tamamlandı"
                    self.completionView.fadeIn(duration: 0.5)
                    self.state = true
                    self.midView.fadeOut()
                    self.collectionView.reloadData()                }
            }
        
            BuyBuddyApi.sharedInstance.completeOrder(orderId: self.orderId!, compileId: id, success: { (HitagValidationResponse, httpResponse) in
                print(HitagValidationResponse)
                
            }) { (err, httpResponse) in
                
            }
        
        }else if(statusCode == -9000){
            if (hitagsTried[currentHitag]! < 3){
                hitagsTried[currentHitag] = 1 + hitagsTried[currentHitag]!
                 let change = self.devicesToOpen.popFirst()
                devicesToOpen.insert(change!)
                currentHitag = devicesToOpen.first!
                self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag)
            }else{
                DispatchQueue.main.async {
                    let acceptAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default) { (_) -> Void in
                        _ = self.blemanager!.bleHandler.disconnectFromHitag()
                        self.midView.timer.invalidate()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.paymentLabel.text = "Ödeme Tamamlandı"
                            self.completionView.fadeIn(duration: 0.5)
                            self.state = true
                            self.midView.fadeOut()
                            self.collectionView.reloadData()
                        }
                    }
                    let alertController = UIAlertController(title: "Uyarı!", message:"Cihazla ilgili bir sorundan dolayı"+self.currentHitag+"numaralı cihanız açılamamıştır.En yakın mağza çalışanına haber verilmiştir.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(acceptAction)
                    self.present(alertController, animated: true, completion: nil)
                }
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

