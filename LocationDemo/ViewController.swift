//
//  ViewController.swift
//  LocationDemo
//
//  Created by Jon Boling on 5/29/18.
//  Copyright © 2018 Walt Boling. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    @IBOutlet weak var locationInfoLabel: UILabel!
    
    @IBAction func findLocation(_ sender: Any) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + error.localizedDescription)
        locationInfoLabel.text = "Error: " + error.localizedDescription
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if (error != nil) {
                print("Error: " + error!.localizedDescription)
                self.locationInfoLabel.text = "Error: " + error!.localizedDescription
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                self.displayLocationDetails(placemark: placemark, location: manager.location!)
            } else {
                print("Error retrieving data")
                self.locationInfoLabel.text = "Error retrieving data"
            }
        }
    }
    
    func displayLocationDetails(placemark: CLPlacemark, location: CLLocation) {
        locationManager.stopUpdatingLocation()
        locationInfoLabel.text = """
        Latitude: \(location.coordinate.latitude)
        Longitude: \(location.coordinate.longitude)
        Locality: \(placemark.locality!)
        Postal Code: \(placemark.postalCode!)
        Administrative Area: \(placemark.administrativeArea!)
        Country: \(placemark.country!)
        """
    }
}

