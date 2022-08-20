//
//  AppDelegate.swift
//  Water Reminder
//
//  Created by macOS on 27/06/22.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Variables | Constants
    let dateFormater = DateFormatter()
    var window: UIWindow?
    var savedDate = String()
    var currenDate = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setLaunchScreen()
        setDarkMode()
        return true
    }
    
    //MARK: - Set Launch Screen
    func setLaunchScreen() {
        let storyBoard = UIStoryboard(name: sbMain, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: idLaunchScreenVC) as! LaunchScreenVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
    }
    
        
    //MARK: - Set Dark Mode
    func setDarkMode() {
        let darkMode = userDefaults.bool(forKey: isDarkMode)
        if darkMode {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
        if !darkMode {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
}
