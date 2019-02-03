//
//  ReferVC.swift
//  MoneyyBox
//
//  Created by viral on 1/30/19.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import SwiftyJSON
import MessageUI

class ReferVC: BaseViewController, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        switch result.rawValue {
        case MessageComposeResult.sent.rawValue:
            
            let alertVC = CPAlertVC.create().config(title: "Success!", message: "Reference link sent successfully.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            alertVC.show(into: self)
        case MessageComposeResult.failed.rawValue:
            let alertVC = CPAlertVC.create().config(title: "Error!", message: "Not able to send text message. Try again.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            alertVC.show(into: self)
        default:
            break
        }
    }
    

    @IBOutlet weak var userEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        onSlideMenuButtonPressed(sender)
    }

    
    @IBAction func inviteBtn(_ sender: Any) {
        if(userEmail.text == ""){
            let alertVC = CPAlertVC.create().config(title: "Error!", message: "Please enter valid phone number.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            alertVC.show(into: self)
        }else{
            
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = [userEmail.text ] as? [String]
            composeVC.body = "Hi, This is kazoom application link. You can direct download form http://www.kazoom.com"
            
            if MFMessageComposeViewController.canSendText(){
                userEmail.text = ""
                self.present(composeVC, animated: true, completion: nil)
                
                
            }else{
                let alertVC = CPAlertVC.create().config(title: "Error!", message: "Not able to send text message. Try again.")
                
                alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                    
                }))
                alertVC.show(into: self)
            }
        }
    }
}
