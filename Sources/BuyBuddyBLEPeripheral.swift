//
//  BuyBuddyBlePeripheral.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import CoreBluetooth


enum ConnectionMode:Int {
    case none
    case pinIO
    case uart
    case info
    case controller
    case dfu
}

protocol BuyBuddyBLEPeripheralDelegate: Any {
    
    var connectionMode:ConnectionMode { get }
    func didReceiveData(_ newData:Data)
    func connectionFinalized()
    func uartDidEncounterError(_ error:NSString)
    
}

class BuyBuddyBLEPeripheral: NSObject, CBPeripheralDelegate {
    
    var currentPeripheral:CBPeripheral!
    var delegate:BuyBuddyBLEPeripheralDelegate!
    var uartService:CBService?
    var rxCharacteristic:CBCharacteristic?
    var txCharacteristic:CBCharacteristic?
    var knownServices:[CBService] = []
    
    //MARK: Utility methods
    
    init(peripheral:CBPeripheral, delegate:BuyBuddyBLEPeripheralDelegate){
        
        super.init()
        
        self.currentPeripheral = peripheral
        self.currentPeripheral.delegate = self
        self.delegate = delegate
    }
    
    
    func didConnect(_ withMode:ConnectionMode) {
        
        //Respond to peripheral connection
        
        //Already discovered services
        if currentPeripheral.services != nil{
            //printLog(self, funcName: "didConnect", logString: "Skipping service discovery")
            peripheral(currentPeripheral, didDiscoverServices: nil)  //already discovered services, DO NOT re-discover. Just pass along the peripheral.
            return
        }
        
        //printLog(self, funcName: "didConnect", logString: "Starting service discovery")
        
        switch withMode.rawValue {
            
        case ConnectionMode.uart.rawValue,
             ConnectionMode.pinIO.rawValue,
             ConnectionMode.controller.rawValue,
             ConnectionMode.dfu.rawValue:
            currentPeripheral.discoverServices([hitagServiceUUID(), dfuServiceUUID(), deviceInformationServiceUUID()])       // Discover dfu and dis (needed to check if update is available)
            
        case ConnectionMode.info.rawValue:
            currentPeripheral.discoverServices(nil)
            break
        default:
            //printLog(self, funcName: "didConnect", logString: "non-matching mode")
            break
        }
        
        //        currentPeripheral.discoverServices([BLEPeripheral.uartServiceUUID(), BLEPeripheral.deviceInformationServiceUUID()])
        //        currentPeripheral.discoverServices(nil)
        
    }
    
    func writeHexString(_ hexString: String) {
        
        writeRawData(Utilities.dataFrom(hex: hexString))
    }
    
    
    func writeString(_ string:NSString){
        
        let data = Data(bytes: UnsafeRawPointer(string.utf8String!), count: string.length)
        //print(String(data: dataWithHexString(hex: pass), encoding: .utf8) ?? "BOŞ")
        
        writeRawData(data)
    }
    
    func writeRawData(_ data:Data) {
        
        //Send data to peripheral
        
        if (txCharacteristic == nil){
            //printLog(self, funcName: "writeRawData", logString: "Unable to write data without txcharacteristic")
            return
        }
        
        var writeType:CBCharacteristicWriteType
        
        if (txCharacteristic!.properties.rawValue & CBCharacteristicProperties.writeWithoutResponse.rawValue) != 0 {
            
            writeType = CBCharacteristicWriteType.withoutResponse
            
        }
            
        else if ((txCharacteristic!.properties.rawValue & CBCharacteristicProperties.write.rawValue) != 0){
            
            writeType = CBCharacteristicWriteType.withResponse
        }
            
        else{
            //printLog(self, funcName: "writeRawData", logString: "Unable to write data without characteristic write property")
            return
        }
        
        //TODO: Test packetization
        
        //send data in lengths of <= 20 bytes
        let dataLength = data.count
        let limit = 36
        
        //Below limit, send as-is
        if dataLength <= limit {
            currentPeripheral.writeValue(data, for: txCharacteristic!, type: writeType)
        }
            
            //Above limit, send in lengths <= 20 bytes
        else {
            
            var len = limit
            var loc = 0
            var idx = 0 //for debug
            
            while loc < dataLength {
                
                let rmdr = dataLength - loc
                if rmdr <= len {
                    len = rmdr
                }
                
                let range = NSMakeRange(loc, len)
                var newBytes = [UInt8](repeating: 0, count: len)
                (data as NSData).getBytes(&newBytes, range: range)
                let newData = Data(bytes: UnsafePointer<UInt8>(newBytes), count: len)
                //                    println("\(self.classForCoder.description()) writeRawData : packet_\(idx) : \(newData.hexRepresentationWithSpaces(true))")
                self.currentPeripheral.writeValue(newData, for: self.txCharacteristic!, type: writeType)
                
                loc += len
                idx += 1
            }
        }
        
    }
    
    
    //MARK: CBPeripheral Delegate methods
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        //Respond to finding a new service on peripheral
        
        if error != nil {
            
            //            handleError("\(self.classForCoder.description()) didDiscoverServices : Error discovering services")
            //printLog(self, funcName: "didDiscoverServices", logString: "\(error.debugDescription)")
            
            return
        }
        
        //        println("\(self.classForCoder.description()) didDiscoverServices")
        
        
        let services = peripheral.services as [CBService]!
        
        for s in services! {
            
            // Service characteristics already discovered
            if (s.characteristics != nil){
                self.peripheral(peripheral, didDiscoverCharacteristicsFor: s, error: nil)    // If characteristics have already been discovered, do not check again
            }
                
                //UART, Pin I/O, or Controller mode
            else if delegate.connectionMode == ConnectionMode.uart ||
                delegate.connectionMode == ConnectionMode.pinIO ||
                delegate.connectionMode == ConnectionMode.controller ||
                delegate.connectionMode == ConnectionMode.dfu {
                if UUIDsAreEqual(s.uuid, secondID: hitagServiceUUID()) {
                    uartService = s
                    peripheral.discoverCharacteristics([passCharacteristicUUID(), rxCharacteristicUUID()], for: uartService!)
                }
            }
                
                // Info mode
            else if delegate.connectionMode == ConnectionMode.info {
                knownServices.append(s)
                peripheral.discoverCharacteristics(nil, for: s)
            }
                
                //DFU / Firmware Updater mode
            else if delegate.connectionMode == ConnectionMode.dfu {
                knownServices.append(s)
                peripheral.discoverCharacteristics(nil, for: s)
            }
        }
        
        //printLog(self, funcName: "didDiscoverServices", logString: "all top-level services discovered")
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        //Respond to finding a new characteristic on service
        
        if error != nil {
            //            handleError("Error discovering characteristics")
            //printLog(self, funcName: "didDiscoverCharacteristicsForService", logString: "\(error.debugDescription)")
            
            return
        }
        
        //printLog(self, funcName: "didDiscoverCharacteristicsForService", logString: "\(service.description) with \(service.characteristics!.count) characteristics")
        
        // UART mode
        if  delegate.connectionMode == ConnectionMode.uart ||
            delegate.connectionMode == ConnectionMode.pinIO ||
            delegate.connectionMode == ConnectionMode.controller ||
            delegate.connectionMode == ConnectionMode.dfu {
            
            for c in (service.characteristics as [CBCharacteristic]!) {
                
                switch c.uuid {
                case rxCharacteristicUUID():         //"6e400003-b5a3-f393-e0a9-e50e24dcca9e"
                    //printLog(self, funcName: "didDiscoverCharacteristicsForService", logString: "\(service.description) : RX")
                    rxCharacteristic = c
                    currentPeripheral.setNotifyValue(true, for: rxCharacteristic!)
                    break
                case passCharacteristicUUID():         //"6e400002-b5a3-f393-e0a9-e50e24dcca9e"
                    //printLog(self, funcName: "didDiscoverCharacteristicsForService", logString: "\(service.description) : TX")
                    txCharacteristic = c
                    break
                default:
                    //                    printLog(self, "didDiscoverCharacteristicsForService", "Found Characteristic: Unknown")
                    break
                }
            }
            
            if rxCharacteristic != nil && txCharacteristic != nil {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate.connectionFinalized()
                })
            }
        }
            // Info mode
        else if delegate.connectionMode == ConnectionMode.info {
            
            for c in (service.characteristics as [CBCharacteristic]!) {
                
                //Read readable characteristic values
                if (c.properties.rawValue & CBCharacteristicProperties.read.rawValue) != 0 {
                    peripheral.readValue(for: c)
                }
                
                peripheral.discoverDescriptors(for: c)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            //            handleError("Error discovering descriptors \(error.debugDescription)")
            //printLog(self, funcName: "didDiscoverDescriptorsForCharacteristic", logString: "\(error.debugDescription)")
            //            return
        }
            
        else {
            if characteristic.descriptors?.count != 0 {
                for d in characteristic.descriptors! {
                    _ = d as CBDescriptor!
                    //printLog(self, funcName: "didDiscoverDescriptorsForCharacteristic", logString: "\(desc.description)")
                    
                    //                    currentPeripheral.readValueForDescriptor(desc)
                }
            }
        }
        
        //Check if all characteristics were discovered
        var allCharacteristics:[CBCharacteristic] = []
        for s in knownServices {
            for c in s.characteristics! {
                allCharacteristics.append(c as CBCharacteristic!)
            }
        }
        for idx in 0...(allCharacteristics.count-1) {
            if allCharacteristics[idx] === characteristic {
                //                println("found characteristic index \(idx)")
                if (idx + 1) == allCharacteristics.count {
                    //                    println("found last characteristic")
                    if delegate.connectionMode == ConnectionMode.info {
                        delegate.connectionFinalized()
                    }
                }
            }
        }
    }
    
    
    //    func peripheral(peripheral: CBPeripheral!, didUpdateValueForDescriptor descriptor: CBDescriptor!, error: NSError!) {
    //
    //        if error != nil {
    ////            handleError("Error reading descriptor value \(error.debugDescription)")
    //            printLog(self, "didUpdateValueForDescriptor", "\(error.debugDescription)")
    ////            return
    //        }
    //
    //        else {
    //            println("descriptor value = \(descriptor.value)")
    //            println("descriptor description = \(descriptor.description)")
    //        }
    //
    //    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        //Respond to value change on peripheral
        
        if error != nil {
            //            handleError("Error updating value for characteristic\(characteristic.description.utf8) \(error.description.utf8)")
            //printLog(self, funcName: "didUpdateValueForCharacteristic", logString: "\(error.debugDescription)")
            return
        }
        
        //UART mode
        if delegate.connectionMode == ConnectionMode.uart || delegate.connectionMode == ConnectionMode.pinIO || delegate.connectionMode == ConnectionMode.controller {
            
            if (characteristic == self.rxCharacteristic){
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate.didReceiveData(characteristic.value!)
                })
                
            }
                //TODO: Finalize for info mode
            else if UUIDsAreEqual(characteristic.uuid, secondID: softwareRevisionStringUUID()) {
                
                //                var swRevision = NSString(string: "")
                //                let bytes:UnsafePointer<Void> = characteristic.value!.bytes
                //                for i in 0...characteristic.value!.length {
                //
                //                    swRevision = NSString(format: "0x%x", UInt8(bytes[i]) )
                //                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate.connectionFinalized()
                })
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        
        //Respond to finding a new characteristic on service
        
        if error != nil {
            //printLog(self, funcName: "didDiscoverIncludedServicesForService", logString: "\(error.debugDescription)")
            return
        }
        
        //printLog(self, funcName: "didDiscoverIncludedServicesForService", logString: "service: \(service.description) has \(service.includedServices?.count) included services")
        
        //        if service.characteristics.count == 0 {
        //            currentPeripheral.discoverIncludedServices(nil, forService: service)
        //        }
        
        for _ in (service.includedServices as [CBService]!) {
            
            //printLog(self, funcName: "didDiscoverIncludedServicesForService", logString: "\(s.description)")
        }
    }
    
    func handleError(_ errorString:String) {
        
        //printLog(self, funcName: "Error", logString: "\(errorString)")
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.uartDidEncounterError(errorString as NSString)
        })
    }
    
    func hitagServiceUUID()->CBUUID{
        
        return CBUUID(string: "0000beef-6275-7962-7564-647966656565")
    }
    
    func passCharacteristicUUID()->CBUUID{
        
        return CBUUID(string: "00007373-6275-7962-7564-647966656565")
    }
    
    func rxCharacteristicUUID()->CBUUID{
        
        return CBUUID(string: "00007478-6275-7962-7564-647966656565")
    }
    
    func UUIDsAreEqual(_ firstID:CBUUID, secondID:CBUUID)->Bool {
        
        if firstID.representativeString() == secondID.representativeString() {
            return true
        }
            
        else {
            return false
        }
    }
    
    func softwareRevisionStringUUID()->CBUUID{
        
        return CBUUID(string: "2A28")
    }
    
    func dfuServiceUUID()->CBUUID{
        
        return CBUUID(string: "00001530-1212-efde-1523-785feabcd123")
    }
    
    func deviceInformationServiceUUID()->CBUUID{
        
        return CBUUID(string: "180A")
    }
}

extension CBUUID {
    
    func representativeString() ->NSString{
        
        let data = self.data
        var byteArray = [UInt8](repeating: 0x0, count: data.count)
        (data as NSData).getBytes(&byteArray, length:data.count)
        let outputString = NSMutableString(capacity: 16)
        
        for value in byteArray {
            
            switch (value){
            case 9:
                outputString.appendFormat("%02x-", value)
                break
            default:
                outputString.appendFormat("%02x", value)
            }
        }
        return outputString
    }
    
    func equalsString(_ toString:String, caseSensitive:Bool, omitDashes:Bool)->Bool {
        
        var aString = toString
        var verdict = false
        var options = NSString.CompareOptions.caseInsensitive
        
        if omitDashes == true {
            aString = toString.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        
        if caseSensitive == true {
            options = NSString.CompareOptions.literal
        }
        
        verdict = aString.compare(self.representativeString() as String, options: options, range: nil, locale: Locale.current) == ComparisonResult.orderedSame
        
        return verdict
    }
}

extension UnicodeScalar {
    var hexNibble:UInt8 {
        let value = self.value
        if 48 <= value && value <= 57 {
            return UInt8(value - 48)
        }
        else if 65 <= value && value <= 70 {
            return UInt8(value - 55)
        }
        else if 97 <= value && value <= 102 {
            return UInt8(value - 87)
        }
        fatalError("\(self) not a legal hex nibble")
    }
}

extension Data {
    init(hex:String) {
        let scalars = hex.unicodeScalars
        var bytes = Array<UInt8>(repeating: 0, count: (scalars.count + 1) >> 1)
        for (index, scalar) in scalars.enumerated() {
            var nibble = scalar.hexNibble
            if index & 1 == 0 {
                nibble <<= 4
            }
            bytes[index >> 1] |= nibble
        }
        self = Data(bytes: bytes)
    }
}
