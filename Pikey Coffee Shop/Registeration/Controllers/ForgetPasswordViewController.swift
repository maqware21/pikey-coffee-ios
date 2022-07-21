//
//  ForgetPasswordViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 03/06/2022.
//

import UIKit

class ForgetPasswordViewController: RegistrationBaseController {

    @IBOutlet weak var emailField: IconTextField!
    @IBOutlet weak var loginMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func setLayout() {
        let text = "Already have an account? Log In"
        
        loginMessage.tappableLabels(string: text,
                                    tappableStrings: ["Log In"],
                                    textColor: .white,
                                    font: UIFont.systemFont(ofSize: 18),
                                    isUnderLined: true)
        
        loginMessage.addRangeGesture(stringRange: "Log In") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
