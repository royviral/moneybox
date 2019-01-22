//
//  AppDelegate.swift
//  MoneyyBox
//
//  Created by suresh on 27/10/18.
//  Copyright © 2018 FH. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GoogleMaps
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let geoCoder = CLGeocoder()
//    let center = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let moneybox = UIColor(red: 0/255, green: 104/255, blue: 55/255, alpha: 1)
        UITabBar.appearance().tintColor = moneybox
        IQKeyboardManager.shared.enable = true
//        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
//        }
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startMonitoringVisits()
        locationManager.delegate = self
        
        // Uncomment following code to enable fake visits
//        locationManager.distanceFilter = 50 // 0
        locationManager.allowsBackgroundLocationUpdates = true // 1
        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.startUpdatingLocation()  // 2
        
        locationManager.startMonitoringSignificantLocationChanges()
        let auth = self.defaults.bool(forKey: "LOGGED_IN_KEY")
        
        if auth{
            let home = HomeVC()
            home.modalPresentationStyle = .custom
        }
        return true
    }

}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // create CLLocation from the coordinates of CLVisit
        let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        
        // Get location description
        AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let place = placemarks?.first {
                let description = "\(place)"
                self.newVisitReceived(visit, description: description)
            }
        }
    }
    func newVisitReceived(_ visit: CLVisit, description: String) {
//        print(visit)
        let location = Location(visit: visit, descriptionString: description)
        
        LocationsStorage.shared.saveLocationOnDisk(location)
//        print(location.date)
        
//        let content = UNMutableNotificationContent()
//        content.title = "New Entry Point added 📌"
//        content.body = location.description
//        content.sound = UNNotificationSound.default()
        
//        print(content)
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: location.dateString, content: content, trigger: trigger)
//
//        center.add(request, withCompletionHandler: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        AppDelegate.geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
            if let place = placemarks?.first {
                let description = "Last visited place: \(place)"
                
                let fakeVisit = FakeVisit(coordinates: location.coordinate, arrivalDate: Date(), departureDate: Date())
                self.newVisitReceived(fakeVisit, description: description)
            }
        }
    }
}

final class FakeVisit: CLVisit {
    private let myCoordinates: CLLocationCoordinate2D
    private let myArrivalDate: Date
    private let myDepartureDate: Date
    
    override var coordinate: CLLocationCoordinate2D {
        return myCoordinates
    }
    
    override var arrivalDate: Date {
        return myArrivalDate
    }
    
    override var departureDate: Date {
        return myDepartureDate
    }
    
    init(coordinates: CLLocationCoordinate2D, arrivalDate: Date, departureDate: Date) {
        myCoordinates = coordinates
        myArrivalDate = arrivalDate
        myDepartureDate = departureDate
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

