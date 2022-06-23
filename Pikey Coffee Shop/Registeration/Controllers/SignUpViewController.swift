//
//  SignUpViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 03/06/2022.
//

import UIKit

class SignUpViewController: RegistrationBaseController {

    @IBOutlet weak var userNameField: IconTextField!
    @IBOutlet weak var emailField: IconTextField!
    @IBOutlet weak var passwordField: IconTextField!
    @IBOutlet weak var termsAndConditionLabel: UILabel!
    @IBOutlet weak var loginMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setLayout() {
        let logintext = "Already have an account? Log In"
        
        loginMessage.tappableLabels(string: logintext,
                                    tappableStrings: ["Log In"],
                                    textColor: .white,
                                    font: UIFont(name: "Cocogoose-light", size: 14.0)!,
                                    isUnderLined: true)
        
        loginMessage.addRangeGesture(stringRange: "Log In") {
            self.navigationController?.popViewController(animated: true)
        }
        
        let termsAndConditiontext = "By signing up, you agree to our Terms and Conditions."
        
        termsAndConditionLabel.tappableLabels(string: termsAndConditiontext,
                                              tappableStrings: ["Terms and Conditions"],
                                              textColor: .white,
                                              font: UIFont(name: "Cocogoose-light", size: 14.0)!,
                                              isUnderLined: true)
        
        termsAndConditionLabel.addRangeGesture(stringRange: termsAndConditiontext) {
            print("terms clicked")
        }
    }
    
    @IBAction func nextButtonClicked() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "VerificationViewController") {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
