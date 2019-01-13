//
//  UserProfileVC.swift
//  MoneyyBox
//
//  Created by viral on 12/9/18.
//  Copyright © 2018 FH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserProfileVC: BaseViewController{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone_no: UITextField!
    @IBOutlet weak var bnkAccountNo: UITextField!
    @IBOutlet weak var bnkIfscCode: UITextField!
    @IBOutlet weak var bnkName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        self.view.addGestureRecognizer(tap)
        self.hideKeyboardTappedArround()
        let auth = defaults.bool(forKey: "LOGGED_IN_KEY")
        let userEmail = defaults.value(forKey: "USER_EMAIL") as? String ?? ""
        let userToken = defaults.value(forKey: "TOKEN") as? String ?? ""
        if !auth && userEmail == ""{
            return
        }else{
            let parameters: [String: Any] = [
                "email": userEmail as String,
                "token": userToken as String
            ]
            Alamofire.request("http://3anglesadvertising.com/api/index.php/auth/get_user", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch response.result
                {
                case .success:
                    
                    let responseJSON = response.result.value as! [String:AnyObject]
                    let JsonData = responseJSON["data"] as! [String:AnyObject]
                    let responseCode = JsonData["response_code"] as! Int
                    if responseCode == 200{
                        
                        self.email.text = userEmail
                        self.name.text = JsonData["name"] as? String ?? ""
                        self.phone_no.text = JsonData["phone_no"] as? String ?? ""
                        self.bnkAccountNo.text = JsonData["bank_acc_no"] as? String ?? ""
                        self.bnkName.text = JsonData["bank_name"] as? String ?? ""
                        self.bnkIfscCode.text = JsonData["bank_ifsc_code"] as? String ?? ""
                    }
                    
                case .failure(let error):
                    print("API failed to load page")
                    print(error)
                }
            }
        }
        
    }

    @IBAction func updateProfileBtnClicked(_ sender: Any) {
        var isTrue = ""
        if (email.text?.isEmpty)! 
        {
            email.layer.borderWidth = 1
            email.layer.borderColor = UIColor.red.cgColor
            isTrue = "Email | "
        }else{
            email.layer.borderColor = UIColor.white.cgColor
            
        }
        if (name.text?.isEmpty)!
        {
            name.layer.borderWidth = 1
            name.layer.borderColor = UIColor.red.cgColor
            isTrue = "Name | "
        }else{
            name.layer.borderColor = UIColor.white.cgColor
            
        }
        if (phone_no.text?.isEmpty)!
        {
            phone_no.layer.borderWidth = 1
            phone_no.layer.borderColor = UIColor.red.cgColor
            isTrue = "Phone No | "
        }else{
            
            phone_no.layer.borderColor = UIColor.white.cgColor
            
        }
        
        if isTrue != ""{
            
            let alertVC = CPAlertVC.create().config(title: "Alert", message: "Requested Fields are required.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            
            alertVC.show(into: self)
        }
        else
        {
            let parameters = [
                "email": email.text!,
                "name": name.text!,
                "phone_no": phone_no.text!,
                "bank_acc_no": bnkAccountNo.text!,
                "bank_name": bnkName.text!,
                "bank_ifsc_code": bnkIfscCode.text!,
                "token": defaults.value(forKey: "TOKEN") as? String ?? ""
                ]
            print(parameters)
            
            Alamofire.request("http://3anglesadvertising.com/api/index.php/auth/update_user", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch response.result
                {
                case .success:
                    
                    let responseJSON = response.result.value as! [String:AnyObject]
                    print(responseJSON)
                    let JsonData = responseJSON["data"] as! [String:AnyObject]
                    let responseCode = JsonData["response_code"] as! Int
                    
                    if responseCode == 200
                    {
                        
                        let alertVC = CPAlertVC.create().config(title: "Success!", message: "Account updated successfully.")
                        
                        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                            
                            
//                            self.dismiss(animated: true, completion: nil)
                            
                        }))
                        
                        alertVC.show(into: self)
                    }
                    else
                    {
                        let alertVC = CPAlertVC.create().config(title: "Error!", message: "Failed to update account.")
                        
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
