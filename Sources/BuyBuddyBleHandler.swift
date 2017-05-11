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
    
    var tempProducts   : [ItemData] = []
    var currentProduct : ItemData?
    var currentIndexPath : IndexPath?
    
    var connectionMode : ConnectionMode = ConnectionMode.uart
    var delegate       : BuyBuddyBlePeripheralDelegate!
    var uartConnect    : BuyBuddyBlePeripheral?
    var centralManager : CBCentralManager!
    var currentDevice  : CBPeripheral!
    var currentTag     : String!
    var connected      : Bool = false
    var hitags         : [String : Hitag] = [:]
    var willDevices    : [String] = []
    var doneDevices    : [String] = []
    

    
    override init() {
        super.init()
        
        /*if singleBuy {
         tempProducts.append(singleItem)
         willDevices.append(singleItem.hitagId)
         }else{
         
         for p in basket{
         tempProducts.append(p)
         willDevices.append(p.hitagId)
         }
         }*/
        
        //self.nextProduct()
    }
    
    init(products : [ItemData]) {
        super.init()
        self.tempProducts = products
        willDevices.append("0100000001")
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        self.nextProduct()
    }
    
    func nextProduct(){
        
        if !tempProducts.isEmpty {
            currentProduct = tempProducts[0]
        }
        
    }
    
    func connectionFinalized() {
        
        connected = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            
            self.uartConnect?.writeString("open")
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
        
        let data = NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!
        print(data)
        if data == "opening" {
            
            self.sendBTServiceNotificationWithIsBluetoothConnected(true)
            
            
        }
        /*let data = NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!
         //print(data)
         
         if data == "opened" {
         willDevices = willDevices.filter{$0 != currentTag}
         doneDevices.append(currentTag)
         currentDevice = nil
         currentTag = ""
         centralManager = CBCentralManager(delegate: self, queue: nil)
         }*/
        
    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(_ isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NotificationCenter.default.post(name: Notification.Name(rawValue: BLEServiceChangedStatusNotification), object: self, userInfo: connectionDetails)
    }
    
    func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let nameOfDeviceFound = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataManufacturerDataKey)  as? Data
        
        if nameOfDeviceFound != nil {
            let data = NSString(data: nameOfDeviceFound!, encoding: String.Encoding.utf8.rawValue)
            
            if data != nil{
                
                if data!.length > 16 {
                    
                    var deviceName : NSString = data!.replacingOccurrences(of: "\0", with: "") as String as NSString
                    deviceName = deviceName.substring(with: NSRange(location: 11, length: 10)) as NSString
                    
                    let deviceNameStr : String = deviceName as String
                    
                    if !deviceNameStr.isEmpty{
                        
                        if hitags[deviceNameStr] == nil {
                            hitags[deviceNameStr] = Hitag(name: deviceNameStr, device: peripheral)
                        }
                        
                        currentDevice = hitags[deviceNameStr]
                        
                        if willDevices.contains(deviceNameStr) {
                            currentTag = deviceNameStr
                            centralManager.stopScan()
                            connectDevice(peripheral)
                        }
                    }
                    
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
