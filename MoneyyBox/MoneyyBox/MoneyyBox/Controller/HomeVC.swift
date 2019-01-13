//
//  HomeVC.swift
//  MoneyyBox
//
//  Created by suresh on 27/10/18.
//  Copyright © 2018 FH. All rights reserved.
//

import Foundation
//import GoogleMaps
import CoreLocation
import MapKit

class HomeVC: BaseViewController  {

    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var distanceCount: UILabel!
    var counter: Float = 0.00
    var setPoint: Int = 0
    var counterUpdated: Float = 0.00
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        mapView.userTrackingMode = .follow
        let annotations = LocationsStorage.shared.locations.map { annotationForLocation($0) }
        mapView.addAnnotations(annotations)
        
        NotificationCenter.default.addObserver(self, selector: #selector(newLocationAdded(_:)), name: .newLocationSaved, object: nil)
        
    }
    
    
    func annotationForLocation(_ location: Location) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = location.dateString
        annotation.coordinate = location.coordinates
        if setPoint == 0 {
            setPoint = 1
        }
        if setPoint == 2{
            counter = counter + 500.00
        }else if setPoint == 1{
            setPoint = 2
        }
        
        
        counterUpdated = counter/1609.344
//        counterUpdated = roundf(counterUpdated * 100) / 100
        
        self.distanceCount.text = String(counterUpdated)+" - Miles"
        
        return annotation
    }
   func mapView(_mapView: MKMapView, rendererFor overlay:MKOverlay) -> MKOverlayRenderer! {
        if(overlay is MKPolyline) {
            let render = MKPolylineRenderer(overlay: overlay)
            render.strokeColor = UIColor.blue.withAlphaComponent(0.5)
            render.lineWidth = 3
            return render
        }
        return nil
        }
    
    @objc func newLocationAdded(_ notification: Notification) {
        guard let location = notification.userInfo?["location"] as? Location else {
            return
        }
        
        let annotation = annotationForLocation(location)
        mapView.addAnnotation(annotation)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func btnMenuClick(_ sender: UIButton)
    {
        onSlideMenuButtonPressed(sender)
    }
    
}
