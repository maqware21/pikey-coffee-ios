//
//  LoginViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 01/06/2022.
//
import UIKit

class LoginViewController: RegistrationBaseController {
    
    @IBOutlet weak var emailField: IconTextField!
    @IBOutlet weak var passwordField: IconTextField!
    @IBOutlet weak var signUpMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setLayout() {
        let text = "Don’t have an account? Sign Up"
        
        signUpMessage.tappableLabels(string: text,
                                     tappableStrings: ["Sign Up"],
                                     textColor: .white,
                                     font: UIFont(name: "Cocogoose-light", size: 14.0)!,
                                     isUnderLined: true)
        
        signUpMessage.addRangeGesture(stringRange: "Sign Up") {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func onClickForgetPassword() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func onClickSingIn() {
        let controller = TabViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
