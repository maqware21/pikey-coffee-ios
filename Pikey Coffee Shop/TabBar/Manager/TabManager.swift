//
//  TabManager.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 07/06/2022.
//

import UIKit

class TabManager {
    
    static let shared = TabManager()
    
    func getTabs(tabs: [Tabs]) -> [TabItemViewController] {
        
        var tabControllers = [TabItemViewController]()
        let storyBoard = UIStoryboard.init(name: "Tabs", bundle: .main)
        
        tabs.forEach { tab in
            switch tab {
            case .Home:
                if let controller = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? TabItemViewController {
                    controller.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "homeIcon"), tag: 1)
                    tabControllers.append(controller)
                }
            case .Orders:
                if let controller = storyBoard.instantiateViewController(withIdentifier: "OrderViewController") as? TabItemViewController {
                    controller.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ordersIcon"), tag: 2)
                    tabControllers.append(controller)
                }
            case .Cart:
                let controller = TabItemViewController()
                controller.tabBarItem = UITabBarItem(title: "", image: nil, tag: 3)
                tabControllers.append(controller)
            case .Notifications:
                if let controller = storyBoard.instantiateViewController(withIdentifier: "NotificationsViewController") as? TabItemViewController {
                    controller.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "alertsIcon"), tag: 4)
                    tabControllers.append(controller)
                }
            case .Profile:
                if let controller = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as? TabItemViewController {
                    controller.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profileIcon"), tag: 5)
                    tabControllers.append(controller)
                }
            }
        }
        
        return tabControllers
    }
}

enum Tabs: String {
    case Home
    case Orders
    case Cart
    case Notifications
    case Profile
}
