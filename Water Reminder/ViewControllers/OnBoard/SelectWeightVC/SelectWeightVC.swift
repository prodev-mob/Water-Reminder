//
//  SelectWeightViewController.swift
//  Water Reminder
//
//  Created by macOS on 27/06/22.
//

import UIKit
import Realm
import RealmSwift

class SelectWeightVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var weightPicker: UIPickerView!
    
    //MARK: - Variables
    var gender: String = ""
    var arrWeight: [Int] = []
    var arrUnit: [String] = ["KG", "LB"]
    var selectedWeight: Int = 50
    var selectedUnit: String = "KG"
    
    //MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        
        //appending weight value in arrWeight
        for i in 1...200 {
            arrWeight.append(i)
        }
        weightPicker.selectRow(49, inComponent: 0, animated: true)
    }
    
    //MARK: - Set Theme
    func setTheme() {
        //set Theme Color, Images According to selected Gender
        if gender == "male" {
            logoImage.image = UIImage(named: "ic_male_weight")
            titleLabel.textColor = UIColor.init(named: "themeTxtColor")
            genderImage.image = UIImage(named: "ic_male")
        } else {
            logoImage.image = UIImage(named: "ic_female_weight")
            titleLabel.textColor = UIColor.init(named: "themeTxtColor3")
            genderImage.image = UIImage(named: "ic_female")
        }
        
        titleLabel.text = "How much do you weigh?"
        
    }
    
    //MARK: - Save Selected weight in Database
    func saveWeight() {
        let userData = realm.objects(UserData.self)[0]
        
        try! realm.write {
            userData.weight = selectedWeight
            userData.unit = selectedUnit
        }
        
        navigation()
    }
    
    //MARK: - Navigation to SelectWakeUpTimeVC
    func navigation() {
        let selectWakeUpTimeViewController: SelectWakeUpTimeVC = storyboard?.instantiateViewController(withIdentifier: idSelectWakeupTimeVC) as! SelectWakeUpTimeVC
        selectWakeUpTimeViewController.gender = gender
        navigationController?.pushViewController(selectWakeUpTimeViewController, animated: true)
    }
    
    //MARK: - NextButton Action
    @IBAction func nextButtonClick(_ sender: UIButton) {
        saveWeight()
    }
    
    //MARK: - BackButton Action
    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UIPickerView Delegate & DataSource Methods
extension SelectWeightVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return arrWeight.count
        } else {
            return arrUnit.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(arrWeight[row])
        } else {
            return arrUnit[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedWeight = arrWeight[row]
        } else {
            selectedUnit = arrUnit[row]
        }
    }
}
