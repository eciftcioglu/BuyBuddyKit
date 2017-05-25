//
//  BuyBuddyBeaconManager.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import CoreLocation
import CoreBluetooth
import UserNotifications
import UIKit


public class BuyBuddyHitagManager : NSObject, CLLocationManagerDelegate,CBCentralManagerDelegate{
      
    static private var sharedInstance: BuyBuddyHitagManager!
    var locationManager:CLLocationManager
    public var activeHitags   : [String : CollectedHitag] = [:]
    var collectedHitags: [CollectedHitag] = []
    var centralManager : CBCentralManager!
    var currentHitag   : String!
    var passiveTimer   : Timer?
    var serverTimer = 0
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers // The accuracy of the location data
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = true
        
        passiveTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.passiveHitagHandler), userInfo: nil, repeats: true)
        RunLoop.current.add(passiveTimer!, forMode: RunLoopMode.commonModes)
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public class func startHitagManager(){
        if sharedInstance == nil{
            sharedInstance = BuyBuddyHitagManager()
        }
    }
    
    public class func getValidNumbersWith(hitagIds: [String]) -> [String : Int] {
        
        var waitingIds : Set = Set<String>()
        var hitagValidations: [String : Int] = [:]
        
        for hitagId in hitagIds {
            waitingIds.insert(hitagId)
        }

        while hitagIds.count != hitagValidations.count{
            for hitagId in waitingIds {
                if let hitag = sharedInstance.activeHitags[hitagId] {
                    if hitag.validPassCheck != nil {
                        hitagValidations[hitagId] = hitag.validPassCheck!
                        waitingIds.remove(hitagId)
                    }
                }
            }
        }
        
        return hitagValidations
    }
    
    public class func validateActiveHitag(hitagId:String)->Bool{
        
        for (key,_) in sharedInstance.activeHitags{
            print("active Hitags Here:")
            if(key == hitagId){
                return true
            }
        }
        return false
    }
    
    func startRanging() {

        for serialNumber in 0..<20 {
            
            let serialHex = String(NSString(format:"%02X", serialNumber))
            let uuidStr = String("0000BEEF-6275-7962-7564-6479666565" + serialHex)
            let uuid   = NSUUID(uuidString: uuidStr!)
            let region = CLBeaconRegion(proximityUUID: uuid! as UUID, identifier: serialHex)
            self.locationManager.startRangingBeacons(in: region)
        }
    }
    
    func startMonitoring() {
        if(locationManager.monitoredRegions.count != 20){
        for serialNumber in 0..<20 {
            
            let serialHex = String(NSString(format:"%02X", serialNumber))
            let uuidStr = String("0000BEEF-6275-7962-7564-6479666565" + serialHex)
            let uuid   = NSUUID(uuidString: uuidStr!)
            let region = CLBeaconRegion(proximityUUID: uuid! as UUID, identifier: serialHex)
            region.notifyEntryStateOnDisplay = true
            self.locationManager.startMonitoring(for: region)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            self.startMonitoring()
            self.startRanging()

        case .denied, .restricted:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOCATION_DENIED"), object: nil)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startUpdatingLocation()

    }
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let beaconsRanged = beacons as [CLBeacon]!
        var data: CollectedHitag = CollectedHitag()
        if let beacon = beaconsRanged?.last {

            let seenTime = CFAbsoluteTimeGetCurrent()
            let uuidDigits = beacon.proximityUUID.uuidString as NSString
            let lastTwoDigit = uuidDigits.substring(from: 34)
        
            data = CollectedHitag(id: (lastTwoDigit) + String(NSString(format:"%04X", Int(beacon.major))) + String(NSString(format:"%04X", Int(beacon.minor))), rssi: beacon.rssi, txPower: nil,timeStamp:seenTime)
            
            if activeHitags[data.id!] == nil{
                activeHitags[data.id!] = data
            }else{
            
                activeHitags[data.id!]?.timeStamp = seenTime

            }
        }
    }
    
    public func passiveHitagHandler(){
        
        for (key,_) in activeHitags{
                let previousTime = activeHitags[key]?.timeStamp
                let currentTime = CFAbsoluteTimeGetCurrent()
                
                if ((currentTime-previousTime!)>10){
                    activeHitags.removeValue(forKey: key)
                }
            }
        
        serverTimer += 1
        if (serverTimer == 3){
        
            print(activeHitags)
            
            for (_,value) in activeHitags{
            collectedHitags.append(value)
            }
        
            if !collectedHitags.isEmpty{
                
            BuyBuddyApi.sharedInstance.postScanRecord(hitags: collectedHitags,success: { (item: BuyBuddyObject<BuyBuddyBase>, httpResponse) in

                
            }) { (err, httpResponse) in
                print(err)
                }
        collectedHitags.removeAll()

        }
        serverTimer = 0
      }
        
    }
  
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        
        if #available(iOS 10.0, *) {
            if central.state ==  CBManagerState.poweredOn {
                
                let options : [String : AnyObject] = NSDictionary(object: NSNumber(value: true as Bool), forKey: CBCentralManagerScanOptionAllowDuplicatesKey as NSCopying) as! [String : AnyObject]
                central.scanForPeripherals(withServices: nil, options: options)
                
            }
            else {
                print("Bluetooth switched off or not initialized")
            }
        } else {
            if central.state.rawValue == CBCentralManagerState.poweredOn.rawValue {
                
                let options : [String : AnyObject] = NSDictionary(object: NSNumber(value: true as Bool), forKey: CBCentralManagerScanOptionAllowDuplicatesKey as NSCopying) as! [String : AnyObject]
                central.scanForPeripherals(withServices: nil, options: options)
            }
            else {
                print("Bluetooth switched off or not initialized")
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var data: CollectedHitag = CollectedHitag()

        if let list = advertisementData["kCBAdvDataServiceUUIDs"] as? [AnyObject],
            (list.contains { ($0 as? CBUUID)!.uuidString.contains("0000BEEF-6275-7962-7564-6479666565") } && advertisementData["kCBAdvDataManufacturerData"] != nil) {
            
            let manufactererData = advertisementData["kCBAdvDataManufacturerData"] as? Data
            let hitagDataByte = [UInt8](manufactererData!)
            //print(hitagDataByte[11])
            //print(hitagDataByte[12])
            
            var hitagIdArray: [UInt8] = [UInt8]()
            
            if hitagDataByte.count < 14{
                return
            }
            
            for index in 2..<12 {
                hitagIdArray.append(hitagDataByte[index])
            }
            
            var validationArray: [UInt8] = []
            validationArray.append(hitagDataByte[12])
            validationArray.append(hitagDataByte[13])
            
            let hitagDataString = NSString(data: Data(hitagIdArray), encoding: String.Encoding.utf8.rawValue)
            let seenTime = CFAbsoluteTimeGetCurrent()

            currentHitag = hitagDataString! as String
            
            data = CollectedHitag(id:currentHitag, rssi: Int(RSSI), txPower: nil,timeStamp:seenTime)
            
            if let value = UInt16(Utilities.byteArrayToHexString(validationArray), radix: 16) {
                data.validPassCheck = Int(value)
            }
    
            if activeHitags[data.id!] == nil{
                activeHitags[data.id!] = data
            }else{
                activeHitags[data.id!]?.timeStamp = seenTime
                activeHitags[data.id!]?.validPassCheck = data.validPassCheck
            }
          
       }
    }
}
