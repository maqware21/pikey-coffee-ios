//
//  EditProfileViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 14/06/2022.
//

import UIKit

class EditProfileViewController: EditProfileBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
