//
//  SelectWakeUpTimeViewController.swift
//  Water Reminder
//
//  Created by macOS on 27/06/22.
//

import UIKit
import Realm
import RealmSwift

class SelectWakeUpTimeVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    //MARK: - Variables | Constant
    let formatter = DateFormatter()
    var gender = ""
    var selectedWakeupTimeInString = ""
    var selectedWakeupTime: Date!
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        setDeafultTime()
        setTimePicker()
    }
    
    //MARK: - Set Theme
    func setTheme() {
        //set Theme Color, Images According to selected Gender
        if gender == "male" {
            logoImage.image = UIImage(named: "ico_wakeUp_male")
            titleLabel.textColor = UIColor.init(named: "themeTxtColor")
            genderImage.image = UIImage(named: "ic_male")
        } else {
            logoImage.image = UIImage(named: "ico_wakeUp_female")
            titleLabel.textColor = UIColor.init(named: "themeTxtColor3")
            genderImage.image = UIImage(named: "ic_female")
        }
    }
    
    //MARK: - BackButton Action
    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - NextButton Action
    @IBAction func nextButtonClick(_ sender: Any) {
        saveWakeUpTime()
    }
    
    //MARK: - Save Wakeup time in Database
    func saveWakeUpTime() {
        let userData = realm.objects(UserData.self)[0]
        try! realm.write {
            userData.wakeUpTime = selectedWakeupTime
            userData.wakeUpTimeInString = selectedWakeupTimeInString
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
        selectedWakeupTimeInString = formatter.string(from: sender.date)
        selectedWakeupTime = sender.date
    }
    
    //MARK: - Default Time
    func setDeafultTime() {
        formatter.timeStyle = .short
        selectedWakeupTimeInString = formatter.string(from: .now)
        selectedWakeupTime = .now
    }
    
    //MARK: - Navigation to SelectBedTimeVC
    func navigation() {
        let selectBedTimeViewController: SelectBedTimeVC = storyboard?.instantiateViewController(withIdentifier: idSelectBedTimeVC) as! SelectBedTimeVC
        selectBedTimeViewController.gender = gender
        navigationController?.pushViewController(selectBedTimeViewController, animated: true)
    }
    
    //MARK: - Show Alert
    func showAlert() {
        let alert = UIAlertController(title: "Select Time", message: "Please Select Wakeup Time", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
