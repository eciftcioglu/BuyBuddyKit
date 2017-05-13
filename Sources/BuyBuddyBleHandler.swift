//
//  BuyBuddyBleHandler.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import CoreBluetooth



let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"


class BuyBuddyBleHandler: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, BuyBuddyBlePeripheralDelegate{
    
    var singleBuy      : Bool = false
    
    var connectionMode : ConnectionMode = ConnectionMode.uart
    var delegate       : BuyBuddyBlePeripheralDelegate!
    var uartConnect    : BuyBuddyBlePeripheral?
    var centralManager : CBCentralManager!
    var currentDevice  : CBPeripheral!
    var connected      : Bool = false
    
    var tempHitags       : [String:String] = [:]
    var hitagsPasswords  : [String : String] = [:]
    var currentHitag     : String!
    var devicesToOpen    : [String] = []
    var openedDevices    : [String] = []
    var currentIndexPath : IndexPath?
    
    
    
    override init() {
        super.init()
        
    }
    
    init(products : [String:String]) {
        super.init()
        self.hitagsPasswords = products
        
        for (key,_) in hitagsPasswords
        {
            devicesToOpen.append(key)
        }
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        //self.nextProduct()
    }
    
    func nextProduct(){
        
        if !tempHitags.isEmpty {
            //  currentProduct = tempProducts.keys.first
        }
        
    }
    
    func connectionFinalized() {
        
        connected = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            
            self.uartConnect?.writeHexString( self.hitagsPasswords[self.currentHitag]!)
            
            //self.centralManager.cancelPeripheralConnection(self.currentDevice)
        }
    }
    
    func uartDidEncounterError(_ error: NSString) {
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        
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
    
    
    
    func didReceiveData(_ newData: Data) {
        
        switch newData {
        case HitagResponse.Error:
            print("Error")
        case HitagResponse.Success:
            self.sendBTServiceNotificationWithIsBluetoothConnected(true)
        case HitagResponse.Unknown:
            print("Error")
        default:
            return
        }
        
    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(_ isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NotificationCenter.default.post(name: Notification.Name(rawValue: BLEServiceChangedStatusNotification), object: self, userInfo: connectionDetails)
    }
    
    func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let manufacturerData = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataManufacturerDataKey)  as? Data
        let deviceName = (advertisementData as NSDictionary)
            .object(forKey: CBAdvertisementDataLocalNameKey) as? Data
        
        if let list = advertisementData["kCBAdvDataServiceUUIDs"] as? [AnyObject], (list.contains { ($0 as? CBUUID)?.uuidString == "0000BEEF-6275-7962-7564-647966656565" } && advertisementData["kCBAdvDataManufacturerData"] != nil) {
            
            let manufactererData = advertisementData["kCBAdvDataManufacturerData"] as? Data
            let hitagDataString = NSString(data: manufactererData!, encoding: String.Encoding.utf8.rawValue)
            let hitagManufacturerData : NSString = hitagDataString!.replacingOccurrences(of: "Y\0", with: "").replacingOccurrences(of: "\0", with: "") as NSString
            
            if hitagManufacturerData.length >= 10 {
                if devicesToOpen.contains(hitagManufacturerData as String) {
                    currentHitag = hitagManufacturerData as String
                    centralManager.stopScan()
                    connectDevice(peripheral)
                    
                }
            }
        }
        
        
        
    }
    
    func connectDevice(_ peripheral: CBPeripheral){
        
        if centralManager.isScanning {
            self.centralManager.stopScan()
        }
        
        self.currentDevice = peripheral
        self.currentDevice.delegate = self
        self.centralManager.connect(peripheral, options: nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        uartConnect = BuyBuddyBlePeripheral(peripheral: self.currentDevice, delegate: self)
        uartConnect?.didConnect(connectionMode)
    }
}
