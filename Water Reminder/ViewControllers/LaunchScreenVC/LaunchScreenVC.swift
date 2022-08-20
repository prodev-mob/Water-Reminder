//
//  LaunchScreenVC.swift
//  Water Reminder
//
//  Created by macOS on 13/07/22.
//

import UIKit

class LaunchScreenVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Water Reminder".localizeString()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getOnBoardingValue()
        }
    }
    
    //MARK: - Get On Boarding
    func getOnBoardingValue() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let onBoarding = userDefaults.bool(forKey: isOnboarding)
        
        if onBoarding {
            let storyBoard = UIStoryboard(name: sbTabBar, bundle: nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: idTabBarController) as! TabBarController
            let navigationController = UINavigationController(rootViewController: tabBarController)
            navigationController.isNavigationBarHidden = true
            appDelegate.window!.rootViewController = navigationController
            appDelegate.window!.makeKeyAndVisible()
        } else {
            let storyBoard = UIStoryboard(name: sbMain, bundle: nil)
            let welcomeVC = storyBoard.instantiateViewController(withIdentifier: idWelcomeVC) as! WelcomeVC
            let navigationController = UINavigationController(rootViewController: welcomeVC)
            navigationController.isNavigationBarHidden = true
            appDelegate.window!.rootViewController = navigationController
            appDelegate.window!.makeKeyAndVisible()
        }
    }
}
