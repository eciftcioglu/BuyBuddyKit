//
//  BuyBuddyBeaconManager.swift
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 11/05/2017.
//
//

import Foundation
import CoreLocation


class BeaconManager : NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = BeaconManager()
    
    var locationManager:CLLocationManager
    var hitags         : [String : CollectedHitag] = [:]

    override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        
        self.locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined{
            
            self.locationManager.requestAlwaysAuthorization()
             
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
    }
    
    func startRanging() {
        
        // NOTE:  The UUIDString here must match the UUID of your iBeacon.  If your
        //        iBeacon UUID is different, replace the string below accordingly!
        let uuid   = NSUUID(uuidString:"0000BEEF-6275-7962-7564-647966656565")
        let region = CLBeaconRegion(proximityUUID: uuid! as UUID, identifier: "")
        self.locationManager.startRangingBeacons(in: region)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            self.startRanging()
        case .denied, .restricted:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOCATION_DENIED"), object: nil)
  
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let beaconsRanged = beacons as [CLBeacon]!
        
        var data: CollectedHitag = CollectedHitag()


        if let beacon = beaconsRanged?.last {
            
            data = CollectedHitag(id: String(Int(beacon.major), radix: 16, uppercase: true) + String(Int(beacon.minor), radix: 16, uppercase: true), rssi: beacon.rssi, txPower: nil)
            print(data)
            hitags[data.id!] = data
            
        }
    }
    
}
