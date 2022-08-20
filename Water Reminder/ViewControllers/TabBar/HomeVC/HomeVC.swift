//
//  HomeVC.swift
//  Water Reminder
//
//  Created by macOS on 28/06/22.
//

import UIKit
import RealmSwift

class HomeVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyGoalMainLabel: UILabel!
    @IBOutlet weak var dailyGoalLabel: UILabel!
    @IBOutlet weak var complateLabel: UILabel!
    @IBOutlet weak var drinkedWaterLabel: UILabel!
    @IBOutlet weak var drinkedWaterBottleLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    
    @IBOutlet weak var waterBottleImageView: UIImageView!
    
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    
    @IBOutlet weak var NSLC_heightLblWater: NSLayoutConstraint!
    
    //MARK: - Variables | Constants
    let date = Date.now
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    var currentDate: String = ""
    var selectedLanguage = ""
    var totalDrinkedWater: Float = 0
    var drinkedWater: Float = 0
    var dailyGoal: Float = 4000
    
    var userActivityData = UserActivityData()
    var totalDrinkedWaterData = TotalDrinkedWater()
    var arrUserData: [UserActivityData] = []
    var arrTotalDrinkedWater: [TotalDrinkedWater] = []
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setDrinkButton()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLanguage()
        setLabelsAndButton()
        getData()
    }
    
    //MARK: - Get Language
    func getLanguage() {
        selectedLanguage = userDefaults.string(forKey: kLanguage) ?? "en"
    }
    
    //MARK: - Set Labels & Buttons
    func setLabelsAndButton() {
        currentDate = dateFormatter.string(from: date)
        unitButton.setTitle("ml".localizeString(), for: .normal)
        dailyGoalMainLabel.text = "Daily Goal".localizeString()
        dailyGoalLabel.text = "\(Int(dailyGoal))" + " " + "ml".localizeString()
        complateLabel.text = "Complete".localizeString()
        drinkButton.setTitle("  " + "Drink".localizeString(), for: .normal)
        
        //set date
        if selectedLanguage == "en" {
            //set date in English
            dateFormatter.dateFormat = "EEEE, MMM d"
            currentDate = dateFormatter.string(from: date)
            dateLabel.text = currentDate.uppercased()
        } else {
            //set date in Hindi
            setWeekday()
            setMonth()
            setDate()
            dateLabel.text = "\(weekDayInHindi), \(monthInHindi) \(dateInHindi)"
        }
    }
    
    //MARK: - Set DrinkButton
    func setDrinkButton() {
        drinkButton.layer.cornerRadius = 25
    }
    
    //MARK: - Get Data
    func getData() {
        dateFormatter.dateFormat = "EEEE, MMM d"
        currentDate = dateFormatter.string(from: .now)

        let userActivityData = realm.objects(UserActivityData.self).filter("dateInString == %@", currentDate)
        let totalDrinkedWaterData = realm.objects(TotalDrinkedWater.self).filter("dateInString == %@", currentDate)
        
        arrUserData = Array(userActivityData)
        arrTotalDrinkedWater = Array(totalDrinkedWaterData)
        
        if arrUserData.count != 0 && arrTotalDrinkedWater.count != 0 {
            totalDrinkedWater = arrTotalDrinkedWater[0].totalDrinkedWater
            drinkedWaterLabel.text = "\(Int(totalDrinkedWater)) " + "ml".localizeString()
            drinkedWaterBottleLabel.text = "\(Int(totalDrinkedWater))"
        } else {
            totalDrinkedWater = 0
            drinkedWaterLabel.text = "0 " + "ml".localizeString()
            drinkedWaterBottleLabel.text = "0"
        }
        
        setBottle()
    }
    
    //MARK: - Save Data
    func saveData() {
        let totalDrinkedWaterData2 = realm.objects(TotalDrinkedWater.self).filter("dateInString == %@", currentDate)
        
        timeFormatter.dateFormat = "h:mm a"
        
        //set userActivityData value
        userActivityData.drinkedWater = drinkedWater
        userActivityData.date = .now
        userActivityData.dateInString = dateFormatter.string(from: .now)
        userActivityData.timeInString = timeFormatter.string(from: .now)
        
        //set totalDrinkedWaterData value
        totalDrinkedWaterData.date = .now
        totalDrinkedWaterData.dateInString = dateFormatter.string(from: .now)
        totalDrinkedWaterData.totalDrinkedWater = totalDrinkedWater
        
        try! realm.write {
            realm.add(userActivityData)
            
            //if object was allready created then update it otherwise create new object
            if totalDrinkedWaterData2.count != 0 {
                totalDrinkedWaterData2[0].date = .now
                totalDrinkedWaterData2[0].dateInString = dateFormatter.string(from: .now)
                totalDrinkedWaterData2[0].totalDrinkedWater = totalDrinkedWater
            } else {
                realm.add(totalDrinkedWaterData)
            }
        }
        
        //reseting variable's value
        totalDrinkedWaterData = TotalDrinkedWater()
        userActivityData = UserActivityData()
        
        getData()
    }
    
    //MARK: - Set Bottle
    func setBottle() {
        let bottleHeight = Float((waterBottleImageView.image?.size.height)!)-130
        let height = totalDrinkedWater * bottleHeight / dailyGoal
        
        //set cornerRadius to waterLabel
        waterLabel.clipsToBounds = true
        waterLabel.layer.cornerRadius = 5
        waterLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // set Bottle Height
        if height > bottleHeight/2 {            
            NSLC_heightLblWater.constant = CGFloat(height)
            drinkedWaterBottleLabel.textColor = .white
            unitButton.setTitleColor(.white, for: .normal)
            
            //set shadow
            drinkedWaterBottleLabel.layer.shadowRadius = 4
            drinkedWaterBottleLabel.layer.shadowOffset = .zero
            drinkedWaterBottleLabel.layer.shadowOpacity = 0.30
            
            unitButton.layer.shadowRadius = 5
            unitButton.layer.shadowOffset = .zero
            unitButton.layer.shadowOpacity = 0.60
            
        } else {
            NSLC_heightLblWater.constant = CGFloat(height)
            drinkedWaterBottleLabel.textColor = UIColor(named: "themeTxtColor")
            unitButton.setTitleColor(UIColor(named: "themeTxtColor"), for: .normal)
            
            //remove shadow
            drinkedWaterBottleLabel.layer.shadowRadius = 0
            drinkedWaterBottleLabel.layer.shadowOffset = .zero
            drinkedWaterBottleLabel.layer.shadowOpacity = 0
            
            unitButton.layer.shadowRadius = 0
            unitButton.layer.shadowOffset = .zero
            unitButton.layer.shadowOpacity = 0
        }
    }
    
    //MARK: - DrinkButton Action
    @IBAction func drinkButtonClick(_ sender: UIButton) {
        //checking totaldrinkedwater value is not bigger than dailygoal
        if totalDrinkedWater >= 4000 {
            showWarningAlert(title: "Warning".localizeString(), message: "You have completed your daily limit..!".localizeString())
        } else {
            showAlert()
        }
    }
    
    //MARK: - Show Alert
    func showAlert() {
        let alert = UIAlertController(title: "Water".localizeString() , message: "How much water do you drinked?".localizeString(), preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?[0].placeholder = "Ex: 200(ml)".localizeString()
        alert.textFields?[0].keyboardType = .numberPad
        
        let drinkButton = UIAlertAction(title: "Drink".localizeString(), style: .default) { drinkButton in
            
            //CheckingTextField Value is not blank or 0
            if alert.textFields?[0].text == "" || alert.textFields?[0].text == "0" {
                self.showWarningAlert(title: "Oops!".localizeString(), message: "Please Set Drinked Water".localizeString())
            } else {
                
                //set drinkedwater value
                self.drinkedWater = Float(alert.textFields?[0].text ?? "0") ?? 0
                
                //checking (totaldrinkedwater + edited drinkedwater) value is not bigger than dailygoal
                if (self.drinkedWater + self.totalDrinkedWater) > self.dailyGoal {
                    self.showWarningAlert(title: "Oops!".localizeString(), message: "Your daily limit is 4000 ml".localizeString())
                } else {
                    
                    //checking drinkedwater value is not 0
                    if self.drinkedWater != 0 && self.drinkedWater > 0 {
                        
                        //set value of totaldrinkedwater lables
                        self.totalDrinkedWater+=self.drinkedWater
                        self.drinkedWaterBottleLabel.text = "\(Int(self.totalDrinkedWater))"
                        self.drinkedWaterLabel.text = "\(Int(self.totalDrinkedWater)) " + "ml".localizeString()
                        
                        self.saveData()
                    } else {
                        self.showWarningAlert(title: "Error".localizeString(), message: "Invalid input..!".localizeString())
                    }
                }
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel".localizeString(), style: .destructive, handler: nil)
        
        //set alert color
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "alertViewColor")
        alert.view.tintColor = UIColor(named: "alertActionColor")
        
        alert.addAction(cancelButton)
        alert.addAction(drinkButton)
        present(alert, animated: true, completion: nil)
    }
    
    func showWarningAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay".localizeString(), style: .default, handler: nil)
        let cancelButton = UIAlertAction(title: "Cancel".localizeString(), style: .destructive, handler: nil)
        
        //set alert color
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "alertViewColor")
        alert.view.tintColor = UIColor(named: "alertActionColor")
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
