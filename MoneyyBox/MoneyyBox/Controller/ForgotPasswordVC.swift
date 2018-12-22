//
//  ForgotPasswordVC.swift
//  MoneyyBox
//
//  Created by suresh on 17/11/18.
//  Copyright © 2018 FH. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import SwiftyJSON

class ForgotPasswordVC: UIViewController {

    
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnsubmit.layer.cornerRadius = 3
    }

    @IBAction func btnForgotPasswordSubmit(_ sender: Any) {
        
        if (txtUserName.text?.isEmpty)!
        {
            let alertVC = CPAlertVC.create().config(title: "Alert", message: "Please enter email")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            
            alertVC.show(into: self)
        }else{
            
            let parameters = [
                "email": txtUserName.text!,
                ]
            
            Alamofire.request("http://3anglesadvertising.com/api/index.php/auth/forgetpassword", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch response.result
                {
                case .success:
                    
                    let responseJSON = response.result.value as! [String:AnyObject]
                    let JsonData = responseJSON["data"] as! [String:AnyObject]
                    let responseCode = JsonData["response_code"] as! Int
                    
                    if responseCode == 200
                    {
                        self.view.makeToast(" Email sent successfully. Kindly check your inbox/spam folder for new password.", duration: 1.0, position: .bottom)
                        
                        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }
                    else
                    {
                        let alertVC = CPAlertVC.create().config(title: "Error!", message: "User not found.Please check your email.")
                        
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
    @IBAction func btnChangePasswordSubmit(_ sender: Any) {
        let alertVC = CPAlertVC.create().config(title: "Success!", message: "Password Change Successfully.")
        
        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
            
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        alertVC.show(into: self)
    }
    @IBAction func back(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
