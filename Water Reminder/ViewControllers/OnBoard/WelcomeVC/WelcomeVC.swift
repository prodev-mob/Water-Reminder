//
//  LunchScreenViewController.swift
//  Water Reminder
//
//  Created by macOS on 27/06/22.
//

import UIKit
import RealmSwift

class WelcomeVC: UIViewController {
    
    //MARK: - Varibales
    var userData = UserData()
    
    //MARK: - LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        storeUserData()
    }

    //MARK: - Let's Go Button Click
    @IBAction func letsGoButtonClick(_ sender: Any) {
        navigation()
    }
    
    //MARK: - Store Data
    func storeUserData() {
        let getUserData = realm.objects(UserData.self)
        try! realm.write {
            if getUserData.count == 0 {
                realm.add(userData)
            }
        }
    }
    
    //MARK: - Navigation to SelectGenderVC
    func navigation() {
        let selectGenderViewController: SelectGenderVC = storyboard?.instantiateViewController(withIdentifier: idSelecteGenderVC) as! SelectGenderVC
        navigationController?.pushViewController(selectGenderViewController, animated: true)
    }
}
