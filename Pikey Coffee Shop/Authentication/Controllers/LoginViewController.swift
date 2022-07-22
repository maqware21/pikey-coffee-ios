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
    
    var viewModel = AuthenticationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.authenticationDelegate = self
        if let _ = UserDefaults.standard[.user] {
            moveToTab(animated: false)
        }
    }
    
    override func setLayout() {
        let text = "Don’t have an account? Sign Up"
        
        signUpMessage.tappableLabels(string: text,
                                     tappableStrings: ["Sign Up"],
                                     textColor: .white,
                                     font: UIFont.systemFont(ofSize: 18),
                                     isUnderLined: true)
        
        signUpMessage.addRangeGesture(stringRange: "Sign Up") {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        passwordField.enablePasswordToggle()
    }
    
    @IBAction func onClickForgetPassword() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func onClickSingIn() {
        if validate() {
            self.showLoader()
            viewModel.loginUser(email: emailField.text ?? "",
                                password: passwordField.text ?? "")
        }
    }
    
    func validate() -> Bool {
        if emailField.isEmpty || !emailField.hasValidEmail {
            self.view.displayNotice(with: "Valid email required")
            return false
        }
        
        if passwordField.isEmpty {
            self.view.displayNotice(with: "Password required")
            return false
        }
        
        return true
    }
    
    func moveToTab(animated: Bool = true) {
        let controller = TabViewController()
        self.navigationController?.pushViewController(controller, animated: animated)
    }
}

extension LoginViewController: AuthenticationDelegate {
    func authenticated(_ user: User?) {
        DispatchQueue.main.async {
            self.removeLoader()
            self.emailField.text = ""
            self.passwordField.text = ""
            self.view.endEditing(true)
            if let user = user {
                UserDefaults.standard[.user] = user
                self.moveToTab()
            } else {
                self.view.displayNotice(with: "Invalid email or password")
            }
        }
    }
}
