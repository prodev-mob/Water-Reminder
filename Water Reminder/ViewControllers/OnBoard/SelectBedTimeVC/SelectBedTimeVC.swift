//
//  SelectBedTimeViewController.swift
//  Water Reminder
//
//  Created by macOS on 28/06/22.
//

import UIKit
import Realm
import RealmSwift

class SelectBedTimeVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        setDeafultTime()
        setTimePicker()
    }
    
    //MARK: - Variable | Constant
    let formatter = DateFormatter()
    var gender = ""
    var selectedBedTimeInString = ""
    var selectedBedTime = Date()
    
    //MARK: - Set Theme
    func setTheme() {
        //set Theme Color, Images According to selected Gender
        if gender == "male" {
            logoImage.image = UIImage(named: "ico_bed_male")
            titleLabel.textColor = UIColor.init(named: "themeTxtColor")
            genderImage.image = UIImage(named: "ico_sleep_male")
        } else {
            logoImage.image = UIImage(named: "ico_bed_female")
            titleLabel.textColor = UIColor.init(named: "themeTxtColor3")
            genderImage.image = UIImage(named: "ico_sleep_female")
        }
    }
    
    //MARK: - BackButton Action
    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - NextButton Action
    @IBAction func nextButtonClick(_ sender: Any) {
        if selectedBedTimeInString == "" {
            showAlert()
        } else {
            saveBedTime()
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: isOnboarding)
        }
    }
    
    //MARK: - Save Wakeup time in Database
    func saveBedTime() {
        let userData = realm.objects(UserData.self)[0]
        try! realm.write {
            userData.bedTimeInString = selectedBedTimeInString
            userData.bedTime = selectedBedTime
        }
       navigation()
    }
    
    //MARK: - Time Picker
    func setTimePicker()  {
        timePicker.datePickerMode = .time
        timePicker.date = Date()
        timePicker.addTarget(self, action: #selector(SelectWakeUpTimeVC.selectedTime), for: .valueChanged)
    }
    
    @objc func selectedTime(sender: UIDatePicker) {
        formatter.timeStyle = .short
        selectedBedTimeInString = formatter.string(from: sender.date)
        selectedBedTime = sender.date
    }
    
    //MARK: - Default Time
    func setDeafultTime() {
        formatter.timeStyle = .short
        selectedBedTimeInString = formatter.string(from: .now)
        selectedBedTime = .now
    }
    
    //MARK: - Navigation to TabBarController
    func navigation() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let storyBoard = UIStoryboard(name: sbTabBar, bundle: nil)
        let tabVC = storyBoard.instantiateViewController(withIdentifier: idTabBarController) as! TabBarController
        var navv = self.navigationController
        navv = UINavigationController(rootViewController: tabVC)
        navv?.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navv
        appDelegate.window?.makeKeyAndVisible()
    }
    
    //MARK: - Show Alert
    func showAlert() {
        let alert = UIAlertController(title: "Select Time", message: "Please Select Bed Time", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
