//
//  HomeVC.swift
//  MoneyyBox
//
//  Created by suresh on 27/10/18.
//  Copyright © 2018 FH. All rights reserved.
//

import UIKit
//import GoogleMaps
import CoreLocation
import MapKit

class HomeVC: BaseViewController , CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var displayView: UIView!
    private var locations: [MKPointAnnotation] = []
    @IBOutlet weak var btnTracking: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
//    lazy var geocoder = CLGeocoder()
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        displayView.layer.cornerRadius = 1
        displayView.layer.borderColor = UIColor.lightGray.cgColor
        displayView.layer.masksToBounds = true
        displayView.layer.borderWidth = 0.5

//        btnStartJourneyOutlet.layer.cornerRadius = 5
//        btnStartJourneyOutlet.layer.masksToBounds = true
//        btnStartJourneyOutlet.layer.borderWidth = 0.5
        
        
        locationManager.delegate = self
        if authorizationStatus == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else{
            return
        }
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        

    }

    @IBAction func btnStartTracking(_ sender: UIButton) {
        
        locationManager.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        
        // Also add to our map so we can remove old values later
        self.locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            let annotationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            // Also remove from the map
            mapView.removeAnnotation(annotationToRemove)
        }
        
        if UIApplication.shared.applicationState == .active {
            mapView.showAnnotations(self.locations, animated: true)
        } else {
            print("App is backgrounded. New location is %@", mostRecentLocation)
        }
    }
        
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func btnMenuClick(_ sender: UIButton)
    {
        onSlideMenuButtonPressed(sender)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
