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
    @IBOutlet weak var plabel: UILabel!
    var viewModel = AuthenticationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsAndConditionsTapped))
        plabel.isUserInteractionEnabled = true
        plabel.addGestureRecognizer(termsTapGesture)
          
          // Style the label
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.alignment = .right  // If you want to center-align the label text
          
        let attributes: [NSAttributedString.Key: Any] = [
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 18)
                ]
        
          let attributeString = NSMutableAttributedString(string: "Privacy policy", attributes: attributes)
        plabel.attributedText = attributeString
        
        viewModel.authenticationDelegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func termsAndConditionsTapped() {
        if let url = URL(string: "https://pikeycoffee.com/policy"),
                  UIApplication.shared.canOpenURL(url) {
                   // Open the URL outside the app in the default web browser
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               }
    }
    
    

    override func setLayout() {
        let logintext = "Already have an account? Log In"
        
        loginMessage.tappableLabels(string: logintext,
                                    tappableStrings: ["Log In"],
                                    textColor: .white,
                                    font: UIFont.systemFont(ofSize: 18),
                                    isUnderLined: true)
        
        loginMessage.addRangeGesture(stringRange: "Log In") { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        let termsAndConditiontext = "By signing up, you agree to our \nTerms and Conditions"
        
        termsAndConditionLabel.tappableLabels(string: termsAndConditiontext,
                                              tappableStrings: ["Terms and Conditions"],
                                              textColor: .white,
                                              font: UIFont.systemFont(ofSize: 18),
                                              isUnderLined: true)
    
        termsAndConditionLabel.addRangeGestures(stringRanges: ["Terms and Conditions", "Privacy Policy"]) {[weak self] val in
            if let controller = self?.storyboard?.instantiateViewController(withIdentifier: "TermsAndPolicyViewController") as? TermsAndPolicyViewController {
                if let url = URL(string: "https://pikeycoffee.com/terms-conditions"),
                          UIApplication.shared.canOpenURL(url) {
                           // Open the URL outside the app in the default web browser
                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
                       }
            }
        }
     
        passwordField.enablePasswordToggle()
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
        
        if emailField.isEmpty || !emailField.hasValidEmail {
            self.view.displayNotice(with: "Valid email required")
            return false
        }
        
        if passwordField.isEmpty {
            self.view.displayNotice(with: "Password required")
            return false
        }
        
        if phoneField.isEmpty {
            self.view.displayNotice(with: "Valid phone number required")
            return false
        }
        
        return true
    }
}

extension SignUpViewController: AuthenticationDelegate {
    func authenticated(_ user: User?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if let _ = user {
                self.view.displayNotice(with: "Please verify your email")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.view.displayNotice(with: "Invalid data.")
            }
        }
    }
}
