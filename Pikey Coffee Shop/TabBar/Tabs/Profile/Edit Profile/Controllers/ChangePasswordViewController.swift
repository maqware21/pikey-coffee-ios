//
//  PasswordViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 15/06/2022.
//

import UIKit

class ChangePasswordViewController: EditProfileBaseViewController {
    
    @IBOutlet weak var oldPasswordField: IconTextField!
    @IBOutlet weak var newPasswordField: IconTextField!
    @IBOutlet weak var confirmPasswordField: IconTextField!
    
    var user: User? = UserDefaults.standard[.user]
    var viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickUpdate() {
        if validate() {
            self.showLoader()
            viewModel.updatePassword(oldPassword: oldPasswordField.text ?? "", newPassword: newPasswordField.text ?? "", confirmPassword: confirmPasswordField.text ?? "")
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.setLayout()
    }
    
    func setLayout() {
        oldPasswordField.enablePasswordToggle()
        newPasswordField.enablePasswordToggle()
        confirmPasswordField.enablePasswordToggle()
    }

    func validate() -> Bool {
        if oldPasswordField.isEmpty {
            self.view.displayNotice(with: "Old Password required")
            return false
        }
        
        if newPasswordField.isEmpty {
            self.view.displayNotice(with: "New Password required")
            return false
        }
        
        if confirmPasswordField.isEmpty {
            self.view.displayNotice(with: "Confirm Password required")
            return false
        }
        
        return true
    }
    
    @IBAction func onclickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChangePasswordViewController: ProfileDelegate {
    func profileUpdated(_ user: User?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if let _ = user {
                self.view.displayNotice(with: "Password changed successfully")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.view.displayNotice(with: "Invalid information")
            }
        }
    }
}
