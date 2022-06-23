//
//  ProfileViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 09/06/2022.
//

import UIKit

class ProfileViewController: TabItemViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickEditProfile() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickChangeAddress() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "MyAddressesViewController") as? MyAddressesViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickLogout() {
        let controller = LogoutView()
        controller.delegate = self
        let vc = PickeySheet(view: controller)
        present(vc, animated: true)
    }
}


extension ProfileViewController: LogoutDelegate {
    func logOut() {
        self.presentedViewController?.dismiss(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
