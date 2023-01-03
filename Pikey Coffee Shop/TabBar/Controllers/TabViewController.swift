//
//  TabViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 06/06/2022.
//

import UIKit

protocol TabHomeDelegate: AnyObject {
    func moveToHome()
}

class TabViewController: UITabBarController {

    private var viewModel = ProfileViewModel()
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .white
        self.tabBar.unselectedItemTintColor = UIColor(hex: "777777")
        self.tabBar.backgroundColor = .black
        
        self.tabBar.shadowColor = UIColor(hex: "222222")
        self.tabBar.shadowOffset = CGSize(width: -6, height: -6)
        self.tabBar.shadowOpacity = 0.7
        self.tabBar.shadowRadius = 16.0
        self.tabBar.masksToBounds = false

        viewControllers = TabManager.shared.getTabs(tabs: [.Home, .Orders, .Cart, .Notifications, .Profile])
        setupMiddleButton()
        viewModel.delegate = self
        viewModel.getAddressList(for: 1)
    }

    // MARK: - Setups

    func setupMiddleButton() {
        
        print(tabBar.height)
        let menuButton = UIButton(frame: .zero)
        let buttonWrapper = HorizontalGradientView(frame: .zero)
        buttonWrapper.translatesAutoresizingMaskIntoConstraints = false
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonWrapper)
        buttonWrapper.addSubview(menuButton)
        NSLayoutConstraint.activate([
            buttonWrapper.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            buttonWrapper.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0),
            buttonWrapper.heightAnchor.constraint(equalToConstant: 70),
            buttonWrapper.widthAnchor.constraint(equalToConstant: 70),
            menuButton.topAnchor.constraint(equalTo: buttonWrapper.topAnchor),
            menuButton.leftAnchor.constraint(equalTo: buttonWrapper.leftAnchor),
            menuButton.rightAnchor.constraint(equalTo: buttonWrapper.rightAnchor),
            menuButton.bottomAnchor.constraint(equalTo: buttonWrapper.bottomAnchor)
        ])

        buttonWrapper.backgroundColor = UIColor.white
        buttonWrapper.cornerRadius = 35

        menuButton.setImage(UIImage(named: "cartIcon"), for: .normal)
        menuButton.tintColor = .black
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }


    // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        if let controller = UIStoryboard(name: "Tabs", bundle: .main).instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            controller.tabHomeDelegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalTransitionStyle = .coverVertical
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.isNavigationBarHidden = true
            self.present(navigationController, animated: true)
        }
    }
}

extension TabViewController: UITabBarControllerDelegate, TabHomeDelegate, ProfileDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 3 {
            return false
        } else {
            return true
        }
    }
    
    func moveToHome() {
        self.selectedIndex = 0
    }
    func addressListUpdated(addresses: AddressList?) {
        if UserDefaults.standard[.selectedAddress] == nil {
            UserDefaults.standard[.selectedAddress] = addresses?.data?.first
        }
    }
}
