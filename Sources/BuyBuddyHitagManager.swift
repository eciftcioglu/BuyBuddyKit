//
//  BuyBuddyBeaconManager.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import CoreLocation


public class BuyBuddyHitagManager : NSObject, CLLocationManagerDelegate {
    
    static public let sharedInstance = BuyBuddyHitagManager()
    
    var locationManager:CLLocationManager
    var hitags         : [String : CollectedHitag] = [:]
    var activeHitags         : [String : CollectedHitag] = [:]
    var passiveHitags         : [String : CollectedHitag] = [:]


    override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        self.locationManager.allowsBackgroundLocationUpdates = true

        if CLLocationManager.authorizationStatus() == .notDetermined{
            
            self.locationManager.requestAlwaysAuthorization()

        }
    }
    
    func startRanging() {
        
        // NOTE:  The UUIDString here must match the UUID of your iBeacon.  If your
        //        iBeacon UUID is different, replace the string below accordingly!
        
        for var serialNumber in 0..<20 {
            
            let serialHex = String(NSString(format:"%02X", serialNumber))
            let uuidStr = String("0000BEEF-6275-7962-7564-6479666565" + serialHex)
            let uuid   = NSUUID(uuidString: uuidStr!)
            let region = CLBeaconRegion(proximityUUID: uuid! as UUID, identifier: "")
            self.locationManager.startRangingBeacons(in: region)
        }
        
    }
    
    func startMonitoring() {
        
        // NOTE:  The UUIDString here must match the UUID of your iBeacon.  If your
        //        iBeacon UUID is different, replace the string below accordingly!
        
        for var serialNumber in 0..<20 {
            
            let serialHex = String(NSString(format:"%02X", serialNumber))
            let uuidStr = String("0000BEEF-6275-7962-7564-6479666565" + serialHex)
            let uuid   = NSUUID(uuidString: uuidStr!)
            let region = CLBeaconRegion(proximityUUID: uuid! as UUID, identifier: "")
            self.locationManager.startMonitoring(for: region)
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            self.startMonitoring()
        case .denied, .restricted:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOCATION_DENIED"), object: nil)
  
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.startRanging()
        manager.startUpdatingLocation()
    }
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        manager.stopUpdatingLocation()

    }

    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let beaconsRanged = beacons as [CLBeacon]!
        
        var data: CollectedHitag = CollectedHitag()
  
        
        if let beacon = beaconsRanged?.last {
            let date = Date()
            let calendar = Calendar.current
            //let hour = calendar.component(.hour, from: date)
            //let minutes = calendar.component(.minute, from: date)
            
            data = CollectedHitag(id: String(Int(beacon.major), radix: 16, uppercase: true) + String(Int(beacon.minor), radix: 16, uppercase: true), rssi: beacon.rssi, txPower: nil,timeStamp:date)
            print(data)
            hitags[data.id!] = data
            print(hitags)
            
        }
    }
}
