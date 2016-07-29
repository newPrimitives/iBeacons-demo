//
//  AppDelegate.swift
//  iBeacons-demo
//
//  Created by Nermin Sehic on 29/07/15.
//  Copyright (c) 2016 Nermin Sehic. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    
    // Init CLLocationManager
    let locationManager = CLLocationManager()
    
    // Define region for monitoring
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "--INSERT YOUR UUID HERE--")!, identifier: "Region")
    
    var enteredRegion = false
    var beacons = []
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Request permission for location updates
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        // Set notification settings
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        
        return true
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case .AuthorizedAlways:
            locationManager.startMonitoringForRegion(region)
            locationManager.startRangingBeaconsInRegion(region)
            locationManager.requestStateForRegion(region)
            
        case .Denied:
            let alert = UIAlertController(title: "Warning", message: "You've disabled location update which is required for this app to work. Go to your phone settings and change the permissions.", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(alertAction)
            
            // Display error message if location updates are declined
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        enteredRegion = true
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        enteredRegion = false
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        
        switch state {
            
        case .Unknown:
            print("I have no memory of this place.")
            
        case .Inside:
            var text = "All aboard the hype train."
            
            if (enteredRegion) {
                text = "Welcome to Millennium Phalcon kiddo."
            }
            
            Notifications.display(text)
            
        case .Outside:
            var text = "Sthaaaaap."
            
            if (!enteredRegion) {
                text = "I find your lack of faith, distrubing!"
            }
            
            Notifications.display(text)
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        self.beacons = beacons
        
        //Send updated beacons array to BeaconTableViewController
        NSNotificationCenter.defaultCenter().postNotificationName("updateBeaconTableView", object: self.beacons)
    }
    
}

