//
//  Constant.swift
//  Water Reminder
//
//  Created by macOS on 28/06/22.
//

import Foundation
import RealmSwift

//MARK: - Controllers ID

//LaunchScreen
public let idLaunchScreenVC = "LaunchScreenVC"

//OnBoarding
public let idWelcomeVC = "WelcomeVC"
public let idSelecteGenderVC = "SelectGenderVC"
public let idSelectWeightVC = "SelectWeightVC"
public let idSelectWakeupTimeVC = "SelectWakeUpTimeVC"
public let idSelectBedTimeVC = "SelectBedTimeVC"

//Tabbar
public let idTabBarController = "TabBarController"
public let idHomeVC = "HomeVC"
public let idHistoryVC = "HistoryVC"
public let idSettingVC = "SettingVC"

//MARK: - StoryBoard ID
public let sbMain = "Main"
public let sbTabBar = "TabBar"

//MARK: - Nib
public let userActivityNibName = "UserActivityTableViewCell"
public let settingNibName = "SettingTableViewCell"

//MARK: - UserDeafult Key
public let isOnboarding = "isOnBoardingComplete"
public let isDarkMode = "isDarkModeOn"
public let kLanguage = "klanguage"

//MARK: - Objects
public let realm = try! Realm()
public let userDefaults = UserDefaults.standard
