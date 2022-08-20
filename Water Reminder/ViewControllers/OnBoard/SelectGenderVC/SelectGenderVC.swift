//
//  SelectGenderViewController.swift
//  Water Reminder
//
//  Created by macOS on 27/06/22.
//

import UIKit
import Realm
import RealmSwift

class SelectGenderVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femalButton: UIButton!
    @IBOutlet weak var maleImageButton: UIButton!
    @IBOutlet weak var femaleImageButton: UIButton!
    
    //MARK: - Varibale
    var userData = UserData()
    var gender: String = String()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - MaleButton Action
    @IBAction func maleButtonClick(_ sender: UIButton) {
        gender = "male"
        femalButton.layer.opacity = 0.50
        femaleImageButton.setBackgroundImage(UIImage(named: "ic_female_sad"), for: .normal)
        maleButton.layer.opacity = 1
        maleImageButton.setBackgroundImage(UIImage(named: "ic_male"), for: .normal)
    }
    
    //MARK: - FemaleButton Action
    @IBAction func femaleButtonClick(_ sender: UIButton) {
        gender = "female"
        maleButton.layer.opacity = 0.50
        maleImageButton.setBackgroundImage(UIImage(named: "ic_male_sad"), for: .normal)
        femalButton.layer.opacity = 1
        femaleImageButton.setBackgroundImage(UIImage(named: "ic_female"), for: .normal)
    }
    
    //MARK: - Save Selected Gender in Database
    func saveGender() {
        let userData = realm.objects(UserData.self)[0]
        try! realm.write {
            userData.gender = gender
        }
    }
    
    //MARK: - BackButton Action
    @IBAction func backButtonClick(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - NextButton Action
    @IBAction func nextButtonClick(_ sender: UIButton) {
        if gender == "" {
            showAlert()
        } else {
           navigation()
        }
    }
    
    //MARK: - Navigation to SelectWeightVC
    func navigation() {
        let selectWeightViewController: SelectWeightVC = storyboard?.instantiateViewController(withIdentifier: idSelectWeightVC) as! SelectWeightVC
        selectWeightViewController.gender = gender
        navigationController?.pushViewController(selectWeightViewController, animated: true)
        saveGender()
    }
    
    //MARK: - Show Alert
    func showAlert() {
        let alert = UIAlertController(title: "Gender", message: "Please Select Gender", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
