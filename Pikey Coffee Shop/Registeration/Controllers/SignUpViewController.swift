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
    @IBOutlet weak var phoneField: IconTextField!
    @IBOutlet weak var termsAndConditionLabel: UILabel!
    @IBOutlet weak var loginMessage: UILabel!
    
    var viewModel = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.registerDelegate = self
        // Do any additional setup after loading the view.
    }

    override func setLayout() {
        let logintext = "Already have an account? Log In"
        
        loginMessage.tappableLabels(string: logintext,
                                    tappableStrings: ["Log In"],
                                    textColor: .white,
                                    font: UIFont.systemFont(ofSize: 18),
                                    isUnderLined: true)
        
        loginMessage.addRangeGesture(stringRange: "Log In") {
            self.navigationController?.popViewController(animated: true)
        }
        
        let termsAndConditiontext = "By signing up, you agree to our Terms and Conditions."
        
        termsAndConditionLabel.tappableLabels(string: termsAndConditiontext,
                                              tappableStrings: ["Terms and Conditions"],
                                              textColor: .white,
                                              font: UIFont.systemFont(ofSize: 18),
                                              isUnderLined: true)
        
        termsAndConditionLabel.addRangeGesture(stringRange: termsAndConditiontext) {
            print("terms clicked")
        }
    }
    
    @IBAction func nextButtonClicked() {
        if validate() {
            self.showLoader()
            viewModel.registerUser(name: userNameField.text ?? "",
                                   email: emailField.text ?? "",
                                   password: passwordField.text ?? "",
                                   phoneNo: phoneField.text ?? "")
        }
    }
    
    func validate() -> Bool {
        if userNameField.isEmpty {
            self.view.displayNotice(with: "Username required")
            return false
        }
        
        if emailField.isEmpty || !(emailField.text ?? "").isValidEmail() {
            self.view.displayNotice(with: "Valid email required")
            return false
        }
        
        if passwordField.isEmpty {
            self.view.displayNotice(with: "Password required")
            return false
        }
        
        if phoneField.isEmpty || !(phoneField.text ?? "").isValidPhone() {
            self.view.displayNotice(with: "Valid phone number required")
            return false
        }
        
        return true
    }
}

extension SignUpViewController: RegisterDelegate {
    func authenticated(_ user: User?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if let _ = user {
                self.view.displayNotice(with: "Please verify your email")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
