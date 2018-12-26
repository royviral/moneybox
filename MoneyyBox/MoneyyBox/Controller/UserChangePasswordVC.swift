//
//  UserChangePasswordVC.swift
//  MoneyyBox
//
//  Created by viral on 12/10/18.
//  Copyright © 2018 FH. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

class UserChangePasswordVC: BaseViewController{
   
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let auth = defaults.bool(forKey: "LOGGED_IN_KEY")
        let userEmail = defaults.value(forKey: "USER_EMAIL") as? String ?? ""
        
        if !auth && userEmail == ""{
            return
        }
        email.text = userEmail
        
    }
    @IBAction func changePasswordBtnClicked(_ sender: Any) {
        var isTrue = ""
        if (email.text?.isEmpty)!
        {
            email.layer.borderWidth = 1
            email.layer.borderColor = UIColor.red.cgColor
            isTrue = "Email | "
        }else{
            email.layer.borderColor = UIColor.white.cgColor
            
        }
        if (currentPassword.text?.isEmpty)!
        {
            currentPassword.layer.borderWidth = 1
            currentPassword.layer.borderColor = UIColor.red.cgColor
            isTrue = "current password | "
        }else{
            currentPassword.layer.borderColor = UIColor.white.cgColor
            
        }
        if (newPassword.text?.isEmpty)!
        {
            newPassword.layer.borderWidth = 1
            newPassword.layer.borderColor = UIColor.red.cgColor
            isTrue = "New password | "
        }else{
            
            newPassword.layer.borderColor = UIColor.white.cgColor
            
        }
        if (confirmPassword.text?.isEmpty)!
        {
            confirmPassword.layer.borderWidth = 1
            confirmPassword.layer.borderColor = UIColor.red.cgColor
            isTrue = "Confirm password | "
        }else{
            
            confirmPassword.layer.borderColor = UIColor.white.cgColor
            if newPassword.text != confirmPassword.text{
                let alertVC = CPAlertVC.create().config(title: "Alert", message: "Password not matched.")
                
                alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                    
                }))
                
                alertVC.show(into: self)
                return
            }
        }
        
        if isTrue != ""{
            
            let alertVC = CPAlertVC.create().config(title: "Alert", message: "Requested Fields are required.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            
            alertVC.show(into: self)
            return
        }
        else
        {
            let parameters = [
                "email": email.text!,
                "password": currentPassword.text!,
                "new_password": newPassword.text!,
                "confirm_new_password": confirmPassword.text!,
                "token": defaults.value(forKey: "TOKEN") as? String ?? ""
            ]
            print(parameters)
            
            Alamofire.request("http://3anglesadvertising.com/api/index.php/auth/changepassword", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch response.result
                {
                case .success:
                    
                    let responseJSON = response.result.value as! [String:AnyObject]
                    print(responseJSON)
                    let JsonData = responseJSON["data"] as! [String:AnyObject]
                    let responseCode = JsonData["response_code"] as! Int
                    
                    if responseCode == 200
                    {
                        
                        let alertVC = CPAlertVC.create().config(title: "Success!", message: "Password updated successfully.")
                        
                        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                            
                            
//                            self.dismiss(animated: true, completion: nil)
                            
                        }))
                        
                        alertVC.show(into: self)
                    }
                    else
                    {
                        let alertVC = CPAlertVC.create().config(title: "Error!", message: "Failed to update password.Check your email and password.")
                        
                        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                            
                            
                        }))
                        
                        alertVC.show(into: self)
                    }
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
            
        }
    }
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender)
    }

}
