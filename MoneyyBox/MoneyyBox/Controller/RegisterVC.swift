//
//  RegisterVC.swift
//  MoneyyBox
//
//  Created by suresh on 27/10/18.
//  Copyright © 2018 FH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class RegisterVC: UIViewController {

    @IBOutlet weak var vwEmail: UIView!
    @IBOutlet weak var vwPassword: UIView!
    @IBOutlet weak var vwConfirmedPassword: UIView!
    @IBOutlet weak var vwName: UIView!
    @IBOutlet weak var vwPhoneNo: UIView!
    @IBOutlet weak var vwAccountHolderName: UIView!
    @IBOutlet weak var vwAccountNo: UIView!
    @IBOutlet weak var btnSubmitOutlet: UIButton!
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmedPassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtBankaccNumber: UITextField!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtIFSCCode: UITextField!
    @IBOutlet weak var btnsubmit: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        btnsubmit.layer.cornerRadius = 3
        

    }

    @IBAction func btnSubmitClick(_ sender: UIButton)
    {
        
        var isTrue = ""
        if (txtEmailID.text?.isEmpty)!
        {
            txtEmailID.layer.borderWidth = 1
            txtEmailID.layer.borderColor = UIColor.red.cgColor
            isTrue = "error"
        }else{
            txtEmailID.layer.borderColor = UIColor.white.cgColor
            
        }
         if (txtPassword.text?.isEmpty)!
        {
            txtPassword.layer.borderWidth = 1
            txtPassword.layer.borderColor = UIColor.red.cgColor
            isTrue = "error"
         }else{
            txtPassword.layer.borderColor = UIColor.white.cgColor
           
        }
         if (txtConfirmedPassword.text?.isEmpty)!
        {
            txtConfirmedPassword.layer.borderWidth = 1
            txtConfirmedPassword.layer.borderColor = UIColor.red.cgColor
            isTrue = "error"
         }else{
            if txtPassword.text == txtConfirmedPassword.text{
                
                let alertVC = CPAlertVC.create().config(title: "Alert", message: "Password not matched.")
                
                alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                    
                }))
                
                alertVC.show(into: self)
                return
            }
            
            txtConfirmedPassword.layer.borderColor = UIColor.white.cgColor
            
        }
         if (txtName.text?.isEmpty)!
        {
            txtName.layer.borderWidth = 1
            txtName.layer.borderColor = UIColor.red.cgColor
            isTrue = "error"
         }else{
            txtName.layer.borderColor = UIColor.white.cgColor
            
        }
        if (txtPhoneNo.text?.isEmpty)!
        {
            txtPhoneNo.layer.borderWidth = 1
            txtPhoneNo.layer.borderColor = UIColor.red.cgColor
            isTrue = "error"
        }else{
            txtPhoneNo.layer.borderColor = UIColor.white.cgColor
            
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
                "email": txtEmailID.text!,
                "password": txtPassword.text!,
                "name": txtName.text!,
                "phone_no": txtPhoneNo.text!,
                "bank_acc_no": txtBankaccNumber.text!,
                "bank_name": txtBankName.text!,
                "bank_ifsc_code": txtIFSCCode.text!,
            ]
            
            Alamofire.request("http://3anglesadvertising.com/api/index.php/auth/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch response.result
                {
                case .success:
                    
                    let responseJSON = response.result.value as! [String:AnyObject]
                    print(responseJSON)
                    let JsonData = responseJSON["data"] as! [String:AnyObject]
                    let responseCode = JsonData["response_code"] as! Int
                    
                    if responseCode == 200
                    {
                        
                        let alertVC = CPAlertVC.create().config(title: "Success!", message: "Registration Successfull. Please Login to Continue.")
                        
                        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                            
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                            
                        }))
                        
                        alertVC.show(into: self)
                    }
                    else
                    {
                        let alertVC = CPAlertVC.create().config(title: "Error!", message: "Failed to register account")
                        
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

    @IBAction func btnBackClick(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    

}
