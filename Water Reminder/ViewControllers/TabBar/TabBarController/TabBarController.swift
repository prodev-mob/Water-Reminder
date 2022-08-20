//
//  TabBarVC.swift
//  Water Reminder
//
//  Created by macOS on 28/06/22.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setVC()
    }

    //MARK: - Set View Controllers
    func setVC() {
        let storyBoard = UIStoryboard(name: sbTabBar, bundle: nil)
        let homeVC: HomeVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let historyVC: HistoryVC = storyBoard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        let settingVC: SettingVC = storyBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        viewControllers = [homeVC, historyVC, settingVC]
    }
}
