//
//  LoginVC.swift
//  MoneyyBox
//
//  Created by suresh on 27/10/18.
//  Copyright © 2018 FH. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {

    
    @IBOutlet weak var vwUserName: UIView!
    @IBOutlet weak var vwPassword: UIView!
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLoginOutlet: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnLoginOutlet.layer.cornerRadius = 3.0
        self.spinner.isHidden = true
        
    }

    @IBAction func btnLoginClick(_ sender: UIButton)
    {
        
       if (txtUserName.text?.isEmpty)!
        {
            let alertVC = CPAlertVC.create().config(title: "Alert", message: "Please enter username")
            
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
        else
        {
            self.spinner.isHidden = false
            self.spinner.startAnimating()
            
            let parameters = [
                "email": txtUserName.text!,
                "password": txtPassword.text!
            ]

            Alamofire.request("http://3anglesadvertising.com/api/index.php/auth/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch response.result
                {
                case .success:
                    
                    let responseJSON = response.result.value as! [String:AnyObject]
                    let JsonData = responseJSON["data"] as! [String:AnyObject]
                    let responseCode = JsonData["response_code"] as! Int

                    if responseCode == 200
                    {
                        
                        let defaults = UserDefaults.standard
                        defaults.set(JsonData["token"] , forKey: "TOKEN")
                        defaults.set(JsonData["first_name"], forKey: "USER_EMAIL")
                        defaults.set(true, forKey: "LOGGED_IN_KEY")
                        defaults.synchronize()
                        
                        
                        self.view.makeToast("Login Successfull", duration: 1.0, position: .bottom)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }
                    else
                    {
                        let alertVC = CPAlertVC.create().config(title: "Error!", message: "Invalid username or password")
                        
                        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                            
                            
                        }))
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        
                        alertVC.show(into: self)
                    }
                    
                case .failure(let error):
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    print(error)
                    return
                }
            }
        }
    }
    
    @IBAction func btnRegisterClick(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnForgotPasswordClick(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
