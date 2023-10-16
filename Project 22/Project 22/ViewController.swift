//
//  ViewController.swift
//  Project 22
//
//  Created by Everett Brothers on 10/6/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var distanceLabel: UILabel!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .lightGray
    }

    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "myBeacon")
        
        locationManager?.startMonitoring(for: beconRegion)
        locationManager?.startRangingBeacons(in: beconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    func update(distance: CLProximity) {
        distanceLabel.textColor = .black
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.lightGray
                self.distanceLabel.text = "UNKNOWN"
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceLabel.text = "FAR"
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceLabel.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceLabel.text = "RIGHT HERE"
            @unknown default:
                self.view.backgroundColor = .black
                self.distanceLabel.textColor = .white
                self.distanceLabel.text = "WTF"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
}

