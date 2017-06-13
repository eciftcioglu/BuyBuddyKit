//
//  BuyBuddyHitagReleaser.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 12/06/2017.
//
//

import Foundation

public protocol BuyBuddyHitagReleaserDelegate{
    func hitagReleaseSuccess()
    func hitagReleaseError()
}

public class BuyBuddyHitagReleaser:BluetoothAlertDelegate,BluetoothConnectionDelegate{
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
    var classDelegate   : BuyBuddyHitagReleaserDelegate?

    
    required public init(orderDetails:OrderDetail,delegate:BuyBuddyHitagReleaserDelegate) {
        classDelegate = delegate
        
        self.hitagIds = orderDetails.hitag_ids!
        self.orderId = orderDetails.sale_id
        
        
        for hitag in self.hitagIds {
            self.devicesToOpen.insert(hitag)
            self.hitagsTried[hitag] = 0
        }
        
        self.currentHitag = self.devicesToOpen.first!
        self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag,viewController: self)

    }
    
    public func connectionTimeOut(hitagId: String) {
        
        
        if (hitagsTried[hitagId]! < 3){
            hitagsTried[hitagId] = 1 + hitagsTried[hitagId]!
            if let change = self.devicesToOpen.popFirst(){
                devicesToOpen.insert(change)
                currentHitag = devicesToOpen.first!
                self.blemanager = BuyBuddyBLEManager(hitagId: self.currentHitag,viewController: self)
            }
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
    
    
    public func connectionComplete(hitagId: String, validateId: Int) {
        BuyBuddyApi.sharedInstance.validateOrder(orderId: self.orderId!, hitagValidations: [hitagId : validateId], success: { (orderResponse, httpResponse) in
            
            self.hitags = orderResponse.data!.hitag_passkeys!
            if (self.blemanager?.bleHandler.sendPassword(password: self.hitags[hitagId]!))! {
            }
            
        }, error: { (err, httpResponse) in
            
        })
        
    }
    
    public func disconnectionComplete(hitagId: String) {
        
    }
    
    public func devicePasswordSent(dataSent: Bool, hitagId: String, responseCode: Int) {
        
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
        

        
        if(devicesWithConnectionError.count == 0){
            _ = self.blemanager!.bleHandler.disconnectFromHitag()
           
            //Success
            classDelegate?.hitagReleaseSuccess()
            
        }else{
            
            _ = self.blemanager!.bleHandler.disconnectFromHitag()
            DispatchQueue.main.async {
                for device in self.devicesWithConnectionError{
                    self.errors += device+" "
                }
          
                self.errors = ""
                //Error
                self.classDelegate?.hitagReleaseError()
         
            }
        }
    }
    
    public func stateChange() {
        
        
    }
}
