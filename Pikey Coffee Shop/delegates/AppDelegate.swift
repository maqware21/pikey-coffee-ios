//
//  AppDelegate.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 01/06/2022.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import CoreLocation
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let beamsClient = PushNotifications.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.beamsClient.start(instanceId: "0b5b7aa7-6ac0-4676-9018-f8adc03d65ad")
        self.beamsClient.registerForRemoteNotifications()
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        GMSServices.provideAPIKey("AIzaSyBJNVE1e22gxakbX-Kw2fLO1V4V89HSGNk")
        GMSPlacesClient.provideAPIKey("AIzaSyBJNVE1e22gxakbX-Kw2fLO1V4V89HSGNk")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      self.beamsClient.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    func logout() {
        UserDefaults.standard[.user] = nil
        UserDefaults.standard[.addresses] = nil
        UserDefaults.standard[.selectedAddress] = nil
        UserDefaults.standard[.cart] = nil
        let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene

        let rootViewController = scene?
            .windows.first(where: { $0.isKeyWindow })?
            .rootViewController
        (rootViewController as? UINavigationController)?.dismiss(animated: true)
        (rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
    }
    
}

