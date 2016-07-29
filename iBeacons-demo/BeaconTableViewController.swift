//
//  BeaconTableViewController.swift
//  iBeacons-demo
//
//  Created by Nermin Sehic on 29/07/15.
//  Copyright (c) 2016 Nermin Sehic. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BeaconTableViewController : UITableViewController {
    
    @IBOutlet var beaconTableView: UITableView!

    var beacons : [CLBeacon] = [CLBeacon]()
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateView(_:)), name: "updateBeaconTableView", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateView(note: NSNotification!){
        beacons = note.object! as! [CLBeacon]
        beaconTableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Beacons in range"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("beaconCell", forIndexPath: indexPath) as UITableViewCell
        
        let major = (beacons[indexPath.row].major as NSNumber).stringValue
        let minor = (beacons[indexPath.row].minor as NSNumber).stringValue
        
        let proximity = beacons[indexPath.row].proximity
        var proximityString = String()
        
        switch proximity {
            case .Near:
                proximityString = "Near"
            
            case .Immediate:
                proximityString = "Immediate"
            
            case .Far:
                proximityString = "Far"
            
            case .Unknown:
                proximityString = "Unknown"
        }
        
        cell.textLabel?.text = "Major: \(major) Minor: \(minor) Proximity: \(proximityString) "
        
        return cell
    }

}
