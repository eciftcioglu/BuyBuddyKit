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
let BLEServiceConnectionNotification = "didConnectToDevice"


class BuyBuddyBleHandler: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, BuyBuddyBlePeripheralDelegate{
    
    var singleBuy      : Bool = false
    var connectionMode : ConnectionMode = ConnectionMode.uart
    var delegate       : BuyBuddyBlePeripheralDelegate!
    var uartConnect    : BuyBuddyBlePeripheral?
    var centralManager : CBCentralManager!
    var currentDevice  : CBPeripheral!
    var connected      : Bool = false
    var timeOutCheck:Bool = false
    private let connectionTimeOutIntvl:TimeInterval = 5
    private var connectionTimer:Timer?
    private var initTimer:Timer?

    var hitagsPasswords  : [String : String] = [:]
    var hitagsTried      : [String : Int] = [:]
    var currentHitag     : String!
    var devicesToOpen    : [String] = []
    var openedDevices    : [String] = []
    var deviceWithError  : [String] = []
    var initHitagId      :  String?
    var validationCode   : Int = 0
    
    override init() {
        super.init()
        
    }
    
    func sendPassword(password: String) -> Bool{
        if connected {
            self.uartConnect?.writeHexString(password)
            return true
        }
        return false
    }
    
    func disconnectFromHitag() -> Bool{
        if connected {
            if currentDevice != nil {
                self.centralManager.cancelPeripheralConnection(self.currentDevice)
                return true
            }
        }
        return false
    }
    
    init(hitagId: String) {
        super.init()
        devicesToOpen.append(hitagId)
        initHitagId = hitagId
        hitagsTried[hitagId] = 0
        centralManager = CBCentralManager(delegate: self, queue: nil)
        initTimer = Timer.scheduledTimer(timeInterval: connectionTimeOutIntvl, target: self, selector:#selector(BuyBuddyBleHandler.connectionTimedOut) , userInfo: nil, repeats: false)
    }
    
    func decideIfNextProduct(){
        if(devicesToOpen.count != 0){
        
            let options : [String : AnyObject] = NSDictionary(object: NSNumber(value: true as Bool), forKey: CBCentralManagerScanOptionAllowDuplicatesKey as NSCopying) as! [String : AnyObject]
            centralManager.scanForPeripherals(withServices: nil, options: options)
        }
    }
    
    func connectionFinalized() {
        
        connected = true
        initTimer?.invalidate()
        connectionTimer = Timer.scheduledTimer(timeInterval: connectionTimeOutIntvl, target: self, selector:#selector(BuyBuddyBleHandler.connectionTimedOut) , userInfo: nil, repeats: false)
    }
    
    func connectionTimedOut() {
        connectionTimer?.invalidate()
        if(connected){
        self.centralManager.cancelPeripheralConnection(currentDevice)
            timeOutCheck = true
        }else{
            if(initHitagId != nil){
                self.sendBTServiceNotificationWithIsBluetoothConnected(false, hitag: initHitagId!, -9000)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connected=false
        if(timeOutCheck){
            let tried = hitagsTried[currentHitag]
            if (tried != nil && tried! < 3){
                timeOutCheck = false
                self.connectDevice(currentDevice)
            }
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
        case HitagResponse.Starting:
            connectionTimer?.invalidate()
            connectionTimer = Timer.scheduledTimer(timeInterval: connectionTimeOutIntvl, target: self, selector:#selector(BuyBuddyBleHandler.connectionTimedOut) , userInfo: nil, repeats: false)

            print("HitagResponse : Starting");
            
        case HitagResponse.ValidationSuccess:
            print("HitagResponse : ValidationSuccess")
            
        case HitagResponse.Error:
            print("HitagResponse : Error");
            self.sendBTServiceNotificationWithIsBluetoothConnected(false, hitag: currentHitag, 2)
            
        case HitagResponse.Success:
            print("HitagResponse : Success");
            connectionTimer?.invalidate()
            self.sendBTServiceNotificationWithIsBluetoothConnected(true, hitag: currentHitag, 1)
            
        case HitagResponse.Unknown:
            print("HitagResponse : Unknown")
            self.sendBTServiceNotificationWithIsBluetoothConnected(false, hitag: currentHitag, -1000)
            
        default:
            self.sendBTServiceNotificationWithIsBluetoothConnected(false,hitag: currentHitag, -1000)
            return
        }
    }
    
    func sendBTServiceNotificationDidConnect(_ hitag:String) {
        var connectionDetails:[String:Any]?
        connectionDetails = ["hitagId" : hitag,
                             "validationCode" : validationCode]
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: BLEServiceConnectionNotification), object: self, userInfo: connectionDetails)
    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(_ isBluetoothConnected: Bool,hitag:String, _ responseCode: Int) {
        var connectionDetails:[String:Any] = [:]
        connectionDetails["isConnected"] = isBluetoothConnected
        connectionDetails["hitagId"] = hitag
        connectionDetails["responseCode"] = responseCode
 
        NotificationCenter.default.post(name: Notification.Name(rawValue: BLEServiceChangedStatusNotification), object: self, userInfo: connectionDetails)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if let list = advertisementData["kCBAdvDataServiceUUIDs"] as? [AnyObject],
            (list.contains { ($0 as? CBUUID)!.uuidString.contains("0000BEEF-6275-7962-7564-6479666565") } && advertisementData["kCBAdvDataManufacturerData"] != nil) {
            
            let manufactererData = advertisementData["kCBAdvDataManufacturerData"] as? Data
            let hitagDataByte = [UInt8](manufactererData!)
            var hitagIdArray: [UInt8] = [UInt8]()
            
            if hitagDataByte.count < 10{
                return
            }
             
            for index in 2..<12 {
                hitagIdArray.append(hitagDataByte[index])
            }
            
            var validationArray: [UInt8] = []
            validationArray.append(hitagDataByte[12])
            validationArray.append(hitagDataByte[13])
            
            
      
            if let hitagDataString = NSString(data: Data(hitagIdArray), encoding: String.Encoding.utf8.rawValue){
                if devicesToOpen.contains(hitagDataString as String) {
                    currentHitag = hitagDataString as String
                    centralManager.stopScan()
                    if let value = UInt16(Utilities.byteArrayToHexString(validationArray), radix: 16) {
                        validationCode = Int(value)
                    }else{
                        validationCode = 0
                    }
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
        let increment: Int = hitagsTried[currentHitag]! + 1
        hitagsTried.updateValue(increment, forKey: currentHitag)
        self.sendBTServiceNotificationDidConnect(currentHitag)
        uartConnect = BuyBuddyBlePeripheral(peripheral: self.currentDevice, delegate: self)
        uartConnect?.didConnect(connectionMode)
    }
}
