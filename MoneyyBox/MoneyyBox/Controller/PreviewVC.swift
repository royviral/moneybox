//
//  PreviewVC.swift
//  MoneyyBox
//
//  Created by viral on 1/19/19.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class PreviewVC: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate {
    
    var takenPhoto:UIImage?
    var locationManager:CLLocationManager!
    var locValueLatitude: Double = 0.0
    var locValueLongitude: Double = 0.0
    var timestamp = Date().timeIntervalSince1970

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = takenPhoto{
            imageView.image = availableImage
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
                
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        let backToCamera = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CamaraVC") as! CamaraVC

        self.navigationController?.pushViewController(backToCamera, animated: true)
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        imagePicker.allowsEditing = false
//        self.present(imagePicker,animated: true, completion: nil)
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
//            imageView.image = image
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func btnMenuClick(_ sender: Any) {
        onSlideMenuButtonPressed(sender as! UIButton)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // create CLLocation from the coordinates of CLVisit
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        locValueLongitude = locValue.longitude
        locValueLatitude = locValue.latitude
        locationManager.stopUpdatingLocation()
    
        
        
    }
    @IBAction func uploadImage(_ sender: Any) {
        
        if ((imageView.image) != nil){
            
            
            let pageURL = "http://3anglesadvertising.com/api/index.php/auth/upload_image"
            let image = imageView.image
            let imageData = UIImageJPEGRepresentation(image!, 0.1)
            
            let parameters = [
                "email": defaults.value(forKey: "USER_EMAIL") as? String ?? "",
                "token": defaults.value(forKey: "TOKEN") as? String ?? "",
                "longitude": String(locValueLongitude) as? String ?? "",
                "latitude": String(locValueLatitude) as? String ?? "",
                "timestamp" : String(timestamp)
                ]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for(key,value) in parameters{
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                
                multipartFormData.append(imageData!, withName: "image",fileName: "IOS_Image.jpeg", mimeType: "image/jpeg")
            }, to: pageURL, headers:nil, encodingCompletion : { encodingResult in
              
                switch encodingResult {
                case.success(let upload, _, _):
//                    upload.uploadProgress { progress in
//                        print("uploading image")
//                    }
//                    upload.validate()
                    upload.responseJSON { response in
                        
                        //debugPrint(response.result.data.upload_data.file_name)
                        let responseJSON = response.result.value as! [String:AnyObject]
                        let JsonData = responseJSON["data"] as! [String:AnyObject]
                        let responseCode = JsonData["response_code"] as! Int
                        if responseCode == 200{
                            
                            let alertVC = CPAlertVC.create().config(title: "Success!", message: "Image uploaded successfully.")
                            
                            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                                let backToCamera = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CamaraVC") as! CamaraVC
                                
                                self.navigationController?.pushViewController(backToCamera, animated: true)
                                
                            }))
                            
                            alertVC.show(into: self)
                            
                        }
                        
                        
                        
                    }
                case .failure(let encodingError):
                    let alertVC = CPAlertVC.create().config(title: "Error!", message: "Something went wrong. Try after sometime.")
                    
                    alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                        let backToCamera = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CamaraVC") as! CamaraVC
                        
                        self.navigationController?.pushViewController(backToCamera, animated: true)
                        
                    }))
                    
                    alertVC.show(into: self)
                }
                
            })
            
        }else{
            let alertVC = CPAlertVC.create().config(title: "Error!", message: "please Select photo.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            
            alertVC.show(into: self)
        }
    }
}

