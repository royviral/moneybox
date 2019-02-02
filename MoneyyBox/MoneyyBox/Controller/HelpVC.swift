//
//  HelpVC.swift
//  MoneyyBox
//
//  Created by viral on 1/30/19.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import SwiftyJSON

class HelpVC: BaseViewController {
    
    var helpValue = 0
    @IBOutlet weak var paymentHelpBtn: UIButton!
    
    @IBOutlet weak var otherHelpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender )
    }
    
    @IBAction func paymentBtn(_ sender: UIButton) {
    
        if sender.isSelected{
            sender.isSelected = false
            
        }else{
            
            if(otherHelpBtn.isSelected){
                otherHelpBtn.isSelected = false
            }
            sender.isSelected = true
        }
    }
    
    @IBAction func otherBtn(_ sender: UIButton) {
    
        if sender.isSelected{
            sender.isSelected = false
            
        }else{
            
            if(paymentHelpBtn.isSelected){
                paymentHelpBtn.isSelected = false
            }
            sender.isSelected = true
        }
    }
    
    @IBOutlet weak var messageTxt: UITextView!
    
    @IBAction func contacBtn(_ sender: Any) {
        if(!paymentHelpBtn.isSelected && !otherHelpBtn.isSelected){
            let alertVC = CPAlertVC.create().config(title: "Error!", message: "Please select any category.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            alertVC.show(into: self)
        }else{
            if(paymentHelpBtn.isSelected){
                helpValue = 1
            }
            if(otherHelpBtn.isSelected){
                helpValue = 0
            }
            
            
            
            
            //alamo request start
            let parameters: [String: Any] = [
                "message": messageTxt.text!,
                "issue_type": String(helpValue),
                "email": UserDefaults.standard.value(forKey: "USER_EMAIL") as? String ?? "",
                "token": UserDefaults.standard.value(forKey: "TOKEN") as? String ?? ""
                ]
            
            
            Alamofire.request("http://3anglesadvertising.com/api/index.php/auth/user_issue", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch response.result
                {
                case .success:
                    
                    let responseJSON = response.result.value as! [String:AnyObject]
                    let JsonData = responseJSON["data"] as! [String:AnyObject]
                    let responseCode = JsonData["response_code"] as! Int
                    
                    if responseCode == 200
                    {
                        
                        let alertVC = CPAlertVC.create().config(title: "Success!", message: "Message sent successfully.")
                        
                        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                            self.paymentHelpBtn.isSelected = false
                            self.otherHelpBtn.isSelected = false
                            self.messageTxt.text = ""
                        }))
                        alertVC.show(into: self)
                        
                        
                    }
                    else
                    {
                        
                        let alertVC = CPAlertVC.create().config(title: "Error!", message: "Something went wrong. Try after sometime.")
                        
                        alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                            
                        }))
                        alertVC.show(into: self)
                    }
                    
                case .failure(let error):
                    print(error)
                    let alertVC = CPAlertVC.create().config(title: "Error!", message: "Request can't send. Try after sometime.")

                    alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {

                    }))
                    alertVC.show(into: self)
                    
                }
            }
            //alamo request end
            
        }
        
    }
}
