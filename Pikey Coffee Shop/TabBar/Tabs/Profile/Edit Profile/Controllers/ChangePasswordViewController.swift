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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.setLayout()
    }
    
    func setLayout() {
        oldPasswordField.enablePasswordToggle()
        newPasswordField.enablePasswordToggle()
        confirmPasswordField.enablePasswordToggle()
    }

    
    
    @IBAction func onclickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
