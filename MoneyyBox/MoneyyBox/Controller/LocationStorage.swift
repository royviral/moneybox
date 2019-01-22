//
//  LocationStorage.swift
//  MoneyyBox
//
//  Created by viral on 12/14/18.
//  Copyright © 2018 FH. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation
import Toast_Swift
import Alamofire
import SwiftyJSON

class LocationsStorage {
    static let shared = LocationsStorage()
    let defaults = UserDefaults.standard
    private(set) var locations: [Location]
    private let fileManager: FileManager
    private let documentsURL: URL
    
    
    init() {
        let fileManager = FileManager.default
        documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        self.fileManager = fileManager
        
        let jsonDecoder = JSONDecoder()
        
        let locationFilesURLs = try! fileManager.contentsOfDirectory(at: documentsURL,
                                                                     includingPropertiesForKeys: nil)
        locations = locationFilesURLs.compactMap { url -> Location? in
            guard !url.absoluteString.contains(".DS_Store") else {
                return nil
            }
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            return try? jsonDecoder.decode(Location.self, from: data)
            }.sorted(by: { $0.date < $1.date })
    }
    
    func saveLocationOnDisk(_ location: Location) {
//        let encoder = JSONEncoder()
//        let timestamp = location.date.timeIntervalSince1970
//        let fileURL = documentsURL.appendingPathComponent("\(timestamp)")
        
//        let data = try! encoder.encode(location)
        //send post request
//        let email = user
        
        
        let auth = defaults.bool(forKey: "LOGGED_IN_KEY")
        let userEmail = defaults.value(forKey: "USER_EMAIL") as? String ?? ""
        let userToken = defaults.value(forKey: "TOKEN") as? String ?? ""
        if !auth && userEmail == ""{
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MM-dd-yyyy HH:mm:ss")
        let new_date_formate = dateFormatter.string(from: location.date)
        
        let parameters: [String: Any] = [
            "latitude": location.latitude ,
            "longitude": location.longitude ,
            "date": new_date_formate,
            "date_string": location.dateString,
            "description": location.description,
            "email": userEmail as String,
            "token": userToken as String
            ]
        
        Alamofire.request("http://3anglesadvertising.com/api/index.php/auth/insert_user_location", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch response.result
            {
                case .success:
                    
                    let responseJSON = response.result.value as! [String:AnyObject]
                    let JsonData = responseJSON["data"] as! [String:AnyObject]
                    let responseCode = JsonData["response_code"] as! Int
                    if responseCode == 200{
                        print("success")
                    }
                
                
                case .failure(let error):
                    
                    print(error)
                }
            }
//        try! data.write(to: fileURL)
        
        //locations.append(location)
        
        NotificationCenter.default.post(name: .newLocationSaved, object: self, userInfo: ["location": location])
    }
    
    func saveCLLocationToDisk(_ clLocation: CLLocation) {
        let currentDate = Date()
        AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let place = placemarks?.first {
                let location = Location(clLocation.coordinate, date: currentDate, descriptionString: "\(place)")
                self.saveLocationOnDisk(location)
            }
        }
    }
}

extension Notification.Name {
    static let newLocationSaved = Notification.Name("newLocationSaved")
}
