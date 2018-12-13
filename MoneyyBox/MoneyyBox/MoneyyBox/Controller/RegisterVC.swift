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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        btnsubmit.layer.cornerRadius = 3

    }

    @IBAction func btnSubmitClick(_ sender: UIButton)
    {
        if (txtEmailID.text?.isEmpty)!
        {
            let alertVC = CPAlertVC.create().config(title: "Alert", message: "Please enter email ID")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            
            alertVC.show(into: self)
        }
        else if (txtPassword.text?.isEmpty)!
        {
            let alertVC = CPAlertVC.create().config(title: "Alert", message: "Please enter password")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            
            alertVC.show(into: self)
        }
        else if (txtConfirmedPassword.text?.isEmpty)!
        {
            let alertVC = CPAlertVC.create().config(title: "Alert", message: "Please enter confirmed password")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            
            alertVC.show(into: self)
        }
        else if (txtName.text?.isEmpty)!
        {
            let alertVC = CPAlertVC.create().config(title: "Alert", message: "Please enter your name")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            
            alertVC.show(into: self)
        }
        else if (txtPhoneNo.text?.isEmpty)!
        {
            let alertVC = CPAlertVC.create().config(title: "Alert", message: "Please enter phone number")
            
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
                "address1": "",
                "address2": "",
                "town": "",
                "city":"",
                "provision": "",
                "country": "",
                "postal_code": "",
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
