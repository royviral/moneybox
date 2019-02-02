//
//  ReferVC.swift
//  MoneyyBox
//
//  Created by viral on 1/30/19.
//  Copyright © 2019 FH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReferVC: BaseViewController {

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
            let alertVC = CPAlertVC.create().config(title: "Error!", message: "Please enter an email.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            alertVC.show(into: self)
        }else{
            let alertVC = CPAlertVC.create().config(title: "Success!", message: "Reference link sent successfully.")
            
            alertVC.addAction(CPAlertAction(title: "Ok", type: .normal, handler: {
                
            }))
            alertVC.show(into: self)
        }
    }
}
