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
     
    var viewModel = AuthenticationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.forgotPasswordDelegate = self
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
        emailField.delegate = self
    }
    
    @IBAction func onClickSend() {
        if validate() {
            self.showLoader()
            viewModel.sendForgotPasswordReq(for: emailField.text ?? "")
        }
    }
    
    func validate() -> Bool {
        if emailField.isEmpty || !emailField.hasValidEmail {
            self.view.displayNotice(with: "Valid email required")
            return false
        }
        
        return true
    }
}

extension ForgetPasswordViewController: ForgotPasswordDelegate, UITextFieldDelegate {
    
    func forgotPasswordResponse(with message: String) {
        DispatchQueue.main.async {
            self.removeLoader()
            self.emailField.text = ""
            self.view.endEditing(true)
            self.view.displayNotice(with: message)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
