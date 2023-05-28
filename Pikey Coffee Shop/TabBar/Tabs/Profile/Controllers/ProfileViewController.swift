//
//  ProfileViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 09/06/2022.
//

import UIKit
import SkeletonView
import StoreKit

class ProfileViewController: TabItemViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setLayout()
        updateProfile()
        // Do any additional setup after loading the view.
    }
    
    func setLayout() {
        SkeletonAppearance.default.tintColor = UIColor(hex: "222222")!.withAlphaComponent(0.7)
        SkeletonAppearance.default.multilineCornerRadius = 8
        userNameLabel.isSkeletonable = true
        emailLabel.isSkeletonable = true
        pointsLabel.isSkeletonable = true
        userNameLabel.skeletonPaddingInsets = .init(top: 0, left: 30, bottom: 0, right: 0)
        emailLabel.skeletonPaddingInsets = .init(top: 0, left: 40, bottom: 0, right: 0)
    }
    
    func updateProfile() {
        userNameLabel.showAnimatedSkeleton()
        emailLabel.showAnimatedSkeleton()
        pointsLabel.showAnimatedSkeleton()
        viewModel.getProfile()
    }
    
    @IBAction func onClickEditProfile() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickChangeAddress() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "MyAddressesViewController") as? MyAddressesViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickLogout() {
        let controller = ConfirmationBottomSheet()
        controller.delegate = self
        controller.titleLabel.text = "Logout"
        controller.messageLabel.text = "Are you sure you want to logout?"
        let vc = PickeySheet(view: controller)
        present(vc, animated: true)
    }
    
    @IBAction func onClickRateApp() {
        guard let scene = UIApplication.shared.foregroundActiveScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
    
    @IBAction func onClickShareApp() {
        if let name = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
          // show alert for not available
        }
    }
    
    @IBAction func onClickHelp() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickGiftCard() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "GiftCardViewController") as? GiftCardViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickReward() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "RewardAndPromotionVC") as? RewardAndPromotionVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickLegal() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "LegalTabVC") as? LegalTabVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickMerchandise() {
        if let vc = UIStoryboard(name: "Profile", bundle: .main).instantiateViewController(withIdentifier: "MerchandiseVC") as? MerchandiseVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickFacebook() {
        
    }
    
    @IBAction func onClickInstagram() {
        
    }
    
    @IBAction func onClickTwitter() {
        
    }
    
    @IBAction func onClickTiktok() {
        
    }
    
    func updateView(user: User) {
        self.userNameLabel.hideSkeleton()
        self.emailLabel.hideSkeleton()
        self.pointsLabel.hideSkeleton()
        self.userNameLabel.text = user.name
        self.emailLabel.text = user.email
        self.pointsLabel.text = "\(user.points ?? 0) Points"
    }
}


extension ProfileViewController: ConfirmationDelegate {
    func confirmAction() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.logout()
        }
    }
}


extension ProfileViewController: ProfileDelegate {
    
    func profileUpdated(_ user: User?) {
        if let user = user {
            DispatchQueue.main.async {
                if var storedUser = UserDefaults.standard[.user] {
                    storedUser.firstName = user.firstName
                    storedUser.lastName = user.lastName
                    storedUser.phoneNumber = user.phoneNumber
                    storedUser.points = user.points
                    UserDefaults.standard[.user] = storedUser
                    self.updateView(user: storedUser)
                }
            }
        }
    }
}

extension ProfileViewController: EditProfileDelegate {
    
    func profileEdited(_ user: User?) {
        if let user = user {
            updateView(user: user)
        }
    }
}

extension UIApplication {
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
