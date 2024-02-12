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
    
    @IBOutlet weak var heightButton: NSLayoutConstraint!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var addressLabelView: UIView!
    var viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setLayout()
        updateProfile()
        addressLabelView.isHidden =  true
        heightButton.constant=0.0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let saved = UserDefaults.standard[.selectedPic] == 0 ? 1 : UserDefaults.standard[.selectedPic]
        profileImageView.image = UIImage(named: "avatar \(saved)")
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
        if let controller = UIStoryboard(name: "Product", bundle: .main).instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController {
            controller.forMerchandise = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func onClickFacebook() {
        if let url = URL(string: "https://www.facebook.com/Pikeycoffee") {
            openURL(url)
        }
    }
    
    @IBAction func onClickInstagram() {
        if let url = URL(string: "https://www.instagram.com/pikeycoffee/") {
            openURL(url)
        }
    }
    
    @IBAction func onClickTwitter() {
        if let url = URL(string: "https://twitter.com/PikeyCoffee") {
            openURL(url)
        }
    }
    
    @IBAction func onClickTiktok() {
        if let url = URL(string: "https://www.tiktok.com/@pikeycoffee") {
            openURL(url)
        }
    }
    
    @IBAction func onClickPic() {
        let controller = AvatarView()
        controller.delegate = self
        let vc = PickeySheet(view: controller)
        present(vc, animated: true)
    }
    
    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
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


extension ProfileViewController: ConfirmationDelegate, AvatarUpdated {
    func confirmAction() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.logout()
        }
    }
    
    func onAvatarUpdate() {
        profileImageView.image = UIImage(named: "avatar \(UserDefaults.standard[.selectedPic])")
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
