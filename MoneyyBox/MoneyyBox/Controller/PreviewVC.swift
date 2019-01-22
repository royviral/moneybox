//
//  PreviewVC.swift
//  MoneyyBox
//
//  Created by viral on 1/19/19.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import Alamofire

class PreviewVC: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var takenPhoto:UIImage?

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = takenPhoto{
            imageView.image = availableImage
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
    @IBAction func uploadImage(_ sender: Any) {
        
//        print(imageView.image)
        
        if ((imageView.image) != nil){
            let alertVC = CPAlertVC.create().config(title: "Success!", message: "Photo uploaded successfully.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                let backToCamera = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CamaraVC") as! CamaraVC
                
                self.navigationController?.pushViewController(backToCamera, animated: true)
                
            }))
            
            alertVC.show(into: self)
            return
            
            let pageURL = "http://3anglesadvertising.com/api/index.php/auth/upload_image"
            let image = imageView.image
            let imageData = UIImageJPEGRepresentation(image!, 0.1)
            
            let base64String = imageData?.base64EncodedString()
            
            let parameters = [
                "email": defaults.value(forKey: "USER_EMAIL") as? String ?? "",
                "token": defaults.value(forKey: "TOKEN") as? String ?? "",
                //"image": base64String as? String ?? ""
            ]
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for(key,value) in parameters{
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                multipartFormData.append(imageData!, withName: "image", mimeType: "image/jpg")
            }, usingThreshold:SessionManager.multipartFormDataEncodingMemoryThreshold ,to: pageURL,method: .post,encodingCompletion : { encodingResult in
              
                switch encodingResult {
                case.success(let upload, _, _):
                    upload.uploadProgress { progress in
                        print("uploading image")
                    }
                    upload.validate()
                    upload.responseJSON { response in
                        let alertVC = CPAlertVC.create().config(title: "Success!", message: "Photo uploaded successfully.")
                        
                        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                            let backToCamera = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CamaraVC") as! CamaraVC
                            
                            self.navigationController?.pushViewController(backToCamera, animated: true)
                            
                        }))
                        
                        alertVC.show(into: self)
                        
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