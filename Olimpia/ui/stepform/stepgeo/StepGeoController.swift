//
//  StepGeoController.swift
//  Olimpia
//
//  Created by Julian on 20/07/20.
//  Copyright © 2020 Julian. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class StepGeoController: UIViewController, CLLocationManagerDelegate  {
 
    var delegate : StepContainerDelegate?
    
    var latitude: String?
    var longitude: String?
    
    @IBOutlet var mapView: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
      super.viewDidLoad()
        self.delegate = navigationController as? StepContainerDelegate
        currentLocation()

    }
    
    
    @IBAction func navigateToPrevious(_ sender: Any) {
        
             navigationController?.popViewController(animated: true)
    }
    
    @IBAction func navigateToNext(_ sender: Any) {
            self.performSegue(withIdentifier: "showStepStatus", sender: self)
    }
    
    
    func currentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       if #available(iOS 11.0, *) {
          locationManager.showsBackgroundLocationIndicator = true
       } else {
          // Fallback on earlier versions
       }
       locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
       let location = locations.last! as CLLocation
       let currentLocation = location.coordinate
       let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
       mapView.setRegion(coordinateRegion, animated: true)
       locationManager.stopUpdatingLocation()
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude:currentLocation.longitude)
        
        annotation.coordinate = centerCoordinate
        annotation.title = "Current location"
        mapView.addAnnotation(annotation)
        
        latitude = String(format: "%f", currentLocation.latitude)
        longitude = String(format: "%f", currentLocation.longitude)
        
        delegate?.updateCurrentLocation(latitude: latitude!, longitude: longitude!)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(error.localizedDescription)
    }
    
}
