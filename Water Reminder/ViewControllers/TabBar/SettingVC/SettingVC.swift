//
//  SettingVC.swift
//  Water Reminder
//
//  Created by macOS on 01/07/22.
//

import UIKit

class SettingVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    
    //MARK: - Constants | Variables
    var arrHeaders = ["Reminder setting", "General", "Personal Information", "Other"]
    var reminderSetting = ["Reminder schedule", "Reminder sound", "Reminder mode", "Further reminder"]
    var general = ["Remove ADS", "Dark Mode", "Unit", "Intake Goal", "Language"]
    var personalInfo = ["Gender", "Weight", "Wake-up time", "Bedtime"]
    var other = ["Hide tips on how to drink water", "Why does Drink Water Reminder not work?", "Reset data", "Feedback", "Share", "Privacy policy"]
    var arrLanguages: [String] = ["English", "हिन्दी"]
    var arrButtonTitles: [String] = ["As device settings", "kg, ml", "4000 ml", "Male", "55 KG", "7:00 AM", "12:00 PM"]
    var subTitle = "Still remind when your goal is achived"
    var selectedLanguage = "en"
    
    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
    var isDarkModeOn = Bool()
    
    //MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        settingLabel.text = "Setting".localizeString()
        settingTableView.register(UINib(nibName: settingNibName, bundle: nil), forCellReuseIdentifier: settingNibName)
        getMode()
        getLanguage()
    }
    
    //MARK: - Get Selected Mode
    func getMode() {
        isDarkModeOn = userDefaults.bool(forKey: isDarkMode)
    }
    
    //MARK: - Get Selected Language
    func getLanguage() {
        selectedLanguage = userDefaults.string(forKey: kLanguage) ?? "en"
    }
    
    //MARK: - Set Mode
    @objc func setMode(sender: UISwitch) {
        let appdelegate = UIApplication.shared
        
        if sender.isOn == true {
            userDefaults.set(true, forKey: isDarkMode)
            appdelegate.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
        
        if sender.isOn == false {
            userDefaults.set(false, forKey: isDarkMode)
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
        
        getMode()
    }
    
    
    //MARK: - Show Alert
    @objc func showAlert() {
        let alert = UIAlertController(title: "Language".localizeString(), message: "Please select language".localizeString(), preferredStyle: .actionSheet)
        
        let english = UIAlertAction(title: "English", style: .default) { english in
            self.selectedLanguage = "en"
            userDefaults.set(self.selectedLanguage, forKey: kLanguage)
            self.settingLabel.text = "Setting".localizeString()
            self.settingTableView.reloadData()
        }
        
        let hindi = UIAlertAction(title: "हिन्दी", style: .default) { english in
            self.selectedLanguage = "hi"
            userDefaults.set(self.selectedLanguage, forKey: kLanguage)
            self.settingLabel.text = "Setting".localizeString()
            self.settingTableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel".localizeString(), style: .destructive, handler: nil)
        
        //set color
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "alertViewColor")
        alert.view.tintColor = UIColor(named: "alertActionColor")
        
        alert.addAction(english)
        alert.addAction(hindi)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableView Delegate & Datasource Methods
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        }
        if section == 3 {
            return 6
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        cell.subtitleLabel.isHidden = true
        cell.settingSwitch.isHidden = true
        cell.button.isHidden = true
        
        //MARK: - Reminder Setting Cell
        if indexPath.section == 0 {
            cell.titleLabel.text = reminderSetting[indexPath.row].localizeString()
            
            if indexPath.row == 2 {
                cell.button.isHidden = false
                cell.button.setTitle(arrButtonTitles[0].localizeString(), for: .normal)
            }
            if indexPath.row == 3 {
                cell.settingSwitch.isHidden = false
                cell.subtitleLabel.isHidden = false
                cell.settingSwitch.isOn = false
                cell.subtitleLabel.text = subTitle.localizeString()
            }
            
            return cell
        }
        
        //MARK: - General Setting Cell
        if indexPath.section == 1 {
            cell.titleLabel.text = general[indexPath.row].localizeString()
            
            if indexPath.row == 1 {
                cell.settingSwitch.isHidden = arrHeaders.count == 0
                cell.settingSwitch.addTarget(self, action: #selector(setMode), for: .valueChanged)
                
                if isDarkModeOn == true {
                    cell.settingSwitch.isOn = true
                }
                if isDarkModeOn == false {
                    cell.settingSwitch.isOn = false
                }
            }
            if indexPath.row == 2 {
                cell.button.isHidden = false
                cell.button.setTitle(arrButtonTitles[1].localizeString(), for: .normal)
            }
            if indexPath.row == 3 {
                cell.button.isHidden = false
                cell.button.setTitle(arrButtonTitles[2].localizeString(), for: .normal)
            }
            if indexPath.row == 4 {
                cell.button.isHidden = false
                
                if selectedLanguage == "en" {
                    cell.button.setTitle("English", for: .normal)
                } else {
                    cell.button.setTitle("हिन्दी", for: .normal)
                }
                
                cell.button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
            }
            
            return cell
        }
        
        //MARK: - Personal Info Cell
        if indexPath.section == 2 {
            cell.titleLabel.text = personalInfo[indexPath.row].localizeString()
            
            if indexPath.row == 0 {
                cell.button.isHidden = false
                cell.button.setTitle(arrButtonTitles[3].localizeString(), for: .normal)
            }
            if indexPath.row == 1 {
                cell.button.isHidden = false
                cell.button.setTitle(arrButtonTitles[4].localizeString(), for: .normal)
            }
            if indexPath.row == 2 {
                cell.button.isHidden = false
                cell.button.setTitle(arrButtonTitles[5].localizeString(), for: .normal)
            }
            if indexPath.row == 3 {
                cell.button.isHidden = false
                cell.button.setTitle(arrButtonTitles[6].localizeString(), for: .normal)
            }
            
            return cell
        }
        
        //MARK: - Other Cell
        else {
            cell.titleLabel.text = other[indexPath.row].localizeString()
            
            if indexPath.row == 0 {
                cell.settingSwitch.isHidden = false
                cell.settingSwitch.isOn = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.bounds.size.width, height: view.frame.height))
        let seprator = UILabel(frame: CGRect(x: 20, y: 18, width: view.bounds.size.width, height: view.frame.height))
        view.backgroundColor = UIColor(named: "cellColor")
        
        label.font = UIFont(name: "Poppins-Medium", size: 12)
        label.textColor = UIColor(named: "headerTxtColor")
        
        seprator.text = "______________"
        seprator.textColor = UIColor(named: "sepratorColor")
        
        view.addSubview(seprator)
        
        if section == 0 {
            label.text = arrHeaders[section].localizeString()
            view.addSubview(label)
            return view
        }
        if section == 1 {
            label.text = arrHeaders[section].localizeString()
            view.addSubview(label)
            return view
        }
        if section == 2 {
            label.text = arrHeaders[section].localizeString()
            view.addSubview(label)
            return view
        }
        else {
            label.text = arrHeaders[section].localizeString()
            view.addSubview(label)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - UIPickerView Delegate & DataSource Methods
extension SettingVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrLanguages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrLanguages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedLanguage = "en"
        } else {
            selectedLanguage = "hi"
        }
    }
}
