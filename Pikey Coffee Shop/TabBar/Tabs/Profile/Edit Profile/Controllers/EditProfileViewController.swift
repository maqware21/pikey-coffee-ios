//
//  EditProfileViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 14/06/2022.
//

import UIKit

protocol EditProfileDelegate: AnyObject {
    func profileEdited(_ user: User?)
}

class EditProfileViewController: EditProfileBaseViewController {
    
    @IBOutlet weak var nameField: IconTextField!
    @IBOutlet weak var emailField: IconTextField!
    @IBOutlet weak var phoneField: IconTextField!
    
    var user: User? = UserDefaults.standard[.user]
    var viewModel = ProfileViewModel()
    weak var delegate: EditProfileDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.setLayout()
        // Do any additional setup after loading the view.
    }
    
    func setLayout() {
        guard let user = user else {
            return
        }
        nameField.text = user.name
        emailField.text = user.email
        emailField.isUserInteractionEnabled = false
        phoneField.text = user.phoneNumber
    }
    
    @IBAction func onClickUpdate() {
        if validate() {
            self.showLoader()
            viewModel.updateProfile(userName: nameField.text ?? "", phoneNumber: phoneField.text ?? "")
        }
    }
    
    func validate() -> Bool {
        if nameField.isEmpty {
            self.view.displayNotice(with: "Name required")
            return false
        }
        
        if phoneField.isEmpty {
            self.view.displayNotice(with: "Phone number required")
            return false
        }
        
        return true
    }
    
    @IBAction func onclickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickChangePassword() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension EditProfileViewController: ProfileDelegate {
    func profileUpdated(_ user: User?) {
        DispatchQueue.main.async {
            self.removeLoader()
            if let user = user {
                if var storedUser = UserDefaults.standard[.user] {
                    storedUser.firstName = user.firstName
                    storedUser.lastName = user.lastName
                    storedUser.phoneNumber = user.phoneNumber
                    UserDefaults.standard[.user] = storedUser
                    self.delegate?.profileEdited(storedUser)
                }
                self.nameField.text = user.name
                self.view.displayNotice(with: "Updated successfully")
            } else {
                self.view.displayNotice(with: "Invalid user information")
            }
        }
    }
}
