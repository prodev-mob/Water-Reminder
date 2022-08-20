//
//  HistoryVC.swift
//  Water Reminder
//
//  Created by macOS on 28/06/22.
//

import UIKit
import RealmSwift
import Charts

class HistoryVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var userActivityTableView: UITableView!
    
    @IBOutlet weak var NSLC_noDataLabelHeight: NSLayoutConstraint!
    
    //MARK: - Variables | Consatnt
    let dateFormatter = DateFormatter()
    
    var drinkedWater: Float = 0
    var totalDrinkedWater: Float = 0
    var dailyGoal: Float = 4000
    var currentDate = String()
    
    var arrUserData: [UserActivityData] = []
    var arrTotalDrinkedWaterData: [TotalDrinkedWater] = []
    var arrAllUserData: [UserActivityData] = []
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "EEEE, MMM d"
        currentDate = dateFormatter.string(from: .now)
        setChartView()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setText()
        getData()
    }
    
    //MARK: - Set DateLabel
    func setText() {
        historyLabel.text = "History".localizeString()
        userActivityTableView.reloadData()
    }
    
    //MARK: - Set ChartView
    func setChartView() {
        //set CornerRadius
        chartView.layer.cornerRadius = 10
        chartView.layer.masksToBounds = true
        chartView.backgroundColor = UIColor(named: "historyCellColor")
        
        //set Properties Label
        chartView.xAxis.labelPosition = .bottom
        chartView.legend.setCustom(entries: [])
        
        //set Label TextColor
        chartView.xAxis.labelTextColor = UIColor(named: "axisLabelColor") ?? .white
        chartView.leftAxis.labelTextColor = UIColor(named: "axisLabelColor") ?? .white
        
        //set GridLines
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.gridColor = UIColor(named: "gridColor") ?? .lightGray
        chartView.rightAxis.gridColor = UIColor(named: "gridColor") ?? .lightGray
        
        //Set Axis granularity
        chartView.xAxis.granularityEnabled = true
        chartView.leftAxis.granularityEnabled = true
        
        //disable Zoom
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
    }
    
    //MARK: - Set TableView
    func setTableView() {
        //register NIB
        userActivityTableView.register(UINib(nibName: userActivityNibName, bundle: nil), forCellReuseIdentifier: userActivityNibName)
        
        //set Shadow
        userActivityTableView.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
        userActivityTableView.layer.shadowRadius = 4
        userActivityTableView.layer.shadowOpacity = 0.3
        userActivityTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        userActivityTableView.layer.masksToBounds = false
    }
    
    //MARK: - GetData
    func getData() {
        let realm = try! Realm()
        let userActivityData = realm.objects(UserActivityData.self).filter("dateInString == %@", currentDate)
        let totalDrinkedWaterData = realm.objects(TotalDrinkedWater.self)
        let allUserActivityData = realm.objects(UserActivityData.self)
        
        arrUserData = Array(userActivityData)
        arrTotalDrinkedWaterData = Array(totalDrinkedWaterData)
        arrAllUserData = Array(allUserActivityData)
        
        //if data is not available then hide tablview
        if arrTotalDrinkedWaterData.count != 0 {
            noDataFoundLabel.isHidden = true
            userActivityTableView.isHidden = false
            totalDrinkedWater = totalDrinkedWaterData.last!.totalDrinkedWater
            updateChart()
            userActivityTableView.reloadData()
        } else {
            userActivityTableView.isHidden = true
            noDataFoundLabel.isHidden = false
        }
    }
    
    //MARK: - UpdateData
    func updateData(index: Int) {
        let userActivityData = realm.objects(UserActivityData.self).filter("dateInString == %@", currentDate)[index]
        let totalDrinkedWaterData = realm.objects(TotalDrinkedWater.self).filter("dateInString == %@", currentDate)
        
        try! realm.write {
            userActivityData.drinkedWater = drinkedWater
            totalDrinkedWaterData[0].totalDrinkedWater = totalDrinkedWater
        }
        
        getData()
    }
    
    //MARK: - DeleteData
    func deleteData(index: Int) {
        let userActivityData = realm.objects(UserActivityData.self).filter("dateInString == %@", currentDate)
        let totalDrinkedWaterData = realm.objects(TotalDrinkedWater.self).filter("dateInString == %@", currentDate)
        
        //deleting selected object
        try! realm.write {
            realm.delete(userActivityData[index])
        }
        
        getData()
        
        //geting totaldrinkedwater
        totalDrinkedWater = 0
        for i in 0..<arrUserData.count {
            totalDrinkedWater += arrUserData[i].drinkedWater
        }
        
        try! realm.write {
            //updating totaldrinkedwater
            if totalDrinkedWaterData.count != 0 {
                totalDrinkedWaterData[0].totalDrinkedWater = totalDrinkedWater
            }
            
            //deleting object
            if totalDrinkedWater == 0 {
                realm.delete(totalDrinkedWaterData[0])
            }
        }
        
        getData()
    }
    
    //MARK: - Update Chart
    func updateChart() {
        var dataEntries: [BarChartDataEntry] = []
        var xAxisLabel: [String] = []
        var yAxisLabel: [String] = []
        
        if arrTotalDrinkedWaterData.count == 1 {
            if arrTotalDrinkedWaterData[0].dateInString == currentDate {
                //store userActivityData for Chart Data Entery
                for i in 0..<arrAllUserData.count {
                    xAxisLabel.append(String(i+1))
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(arrAllUserData[i].drinkedWater))
                    dataEntries.append(dataEntry)
                }
            } else {
                //store totalDrinkedWaterData for Chart Data Entery
                for i in 0..<arrTotalDrinkedWaterData.count {
                    xAxisLabel.append(String(i+1))
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(arrTotalDrinkedWaterData[i].totalDrinkedWater))
                    dataEntries.append(dataEntry)
                }
            }
        } else {
            //store totalDrinkedWaterData for Chart Data Entery
            for i in 0..<arrTotalDrinkedWaterData.count {
                xAxisLabel.append(String(i+1))
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(arrTotalDrinkedWaterData[i].totalDrinkedWater))
                dataEntries.append(dataEntry)
            }
        }
        
        //store yAxis Label Data
        for i in stride(from: 100, to: Int(dailyGoal)+100, by: 200){
            yAxisLabel.append(String(i))
        }
        
        //Chart Data Entry
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        let chartData = BarChartData(dataSet: chartDataSet)
        chartDataSet.highlightColor = NSUIColor(named: "barColor")!
        chartDataSet.colors = [NSUIColor(named: "barColor")!]
        chartDataSet.drawValuesEnabled = true
        chartData.barWidth = 0.2
        
        //set Axis Label value
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabel)
        chartView.rightAxis.valueFormatter = IndexAxisValueFormatter(values: yAxisLabel)
        chartView.data = chartData
    }
    
    //MARK: - ShowAlert {
    func showAlert(index: Int) {
        let alert = UIAlertController(title: "How much water do you drinked?".localizeString(), message: "", preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "themeBgColor")
        
        //Set TextField In AlertView
        alert.addTextField(configurationHandler: nil)
        alert.textFields?[0].placeholder = "Ex: 200(ml)"
        alert.textFields?[0].text = "\(arrUserData[index].drinkedWater)"
        alert.textFields?[0].keyboardType = .numberPad
        
        let editButton = UIAlertAction(title: "Edit".localizeString(), style: .default) { editButton in
            
            //CheckingTextField Value is not blank or 0
            if alert.textFields?[0].text == "" || alert.textFields?[0].text == "0" {
                self.showWarningAlert(title: "Oops!".localizeString(), message: "Please Set Drinked Water".localizeString())
            } else {
                
                //set drinkedwater value
                self.drinkedWater = Float(alert.textFields?[0].text ?? "0") ?? 0
                
                //removing drinkedwater value
                self.totalDrinkedWater = self.totalDrinkedWater - self.arrUserData[index].drinkedWater
                
                //checking (totaldrinkedwater + edited drinkedwater) value is not bigger than dailygoal
                if (self.drinkedWater + self.totalDrinkedWater) > self.dailyGoal {
                    self.showWarningAlert(title: "Oops!".localizeString(), message: "Your daily limit is 4000 ml".localizeString())
                } else {
                    
                    //checking drinkedwater value is not 0
                    if self.drinkedWater != 0 && self.drinkedWater > 0 {
                        self.updateData(index: index)
                        
                        //geting totaldrinedwater
                        self.totalDrinkedWater = 0
                        for i in 0..<self.arrUserData.count {
                            self.totalDrinkedWater += self.arrUserData[i].drinkedWater
                        }
                        
                        //updating totaldrinkedwater
                        self.updateData(index: index)
                    } else {
                        self.showWarningAlert(title: "Error".localizeString(), message: "Invalid input..!".localizeString())
                    }
                }
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel".localizeString(), style: .destructive) { cancelButton in
            self.userActivityTableView.reloadData()
        }
        
        //set alert color
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "alertViewColor")
        alert.view.tintColor = UIColor(named: "alertActionColor")
        
        alert.addAction(cancelButton)
        alert.addAction(editButton)
        present(alert, animated: true, completion: nil)
    }
    
    func showWarningAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "themeBgColor")
        
        let okButton = UIAlertAction(title: "Okay".localizeString(), style: .default) { okButton in
            self.userActivityTableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel".localizeString(), style: .destructive) { cancelButton in
            self.userActivityTableView.reloadData()
        }
        
        //set alert color
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "alertViewColor")
        alert.view.tintColor = UIColor(named: "alertActionColor")
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func showDeleteCellAlert(index: Int) {
        let alert = UIAlertController(title: "Delete".localizeString(), message: "Do you want to delete the selected cell?".localizeString() , preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "Delete".localizeString(), style: .default) { deleteButton in
            self.deleteData(index: index)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel".localizeString(), style: .destructive) { cancelButton in
            self.userActivityTableView.reloadData()
        }
        
        //set alert color
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "alertViewColor")
        alert.view.tintColor = UIColor(named: "alertActionColor")
        
        alert.addAction(cancelButton)
        alert.addAction(deleteButton)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableView DataSource & Delegate Methods
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserActivityTableViewCell = userActivityTableView.dequeueReusableCell(withIdentifier: "UserActivityTableViewCell", for: indexPath) as! UserActivityTableViewCell
        
        cell.drinkedWaterLabel.text = "\(arrUserData[indexPath.row].drinkedWater)ml"
        cell.timeLabel.text = "\(arrUserData[indexPath.row].timeInString)"
        
        //set corner radius to last cell
        if indexPath.last == arrUserData.count-1 {
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.clipsToBounds = true
            return cell
        } else {
            cell.clipsToBounds = false
            cell.layer.masksToBounds = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-1, height: 50))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.bounds.size.width, height: view.frame.height))
        let seprator = UILabel(frame: CGRect(x: 0, y: view.frame.height-2, width: view.bounds.size.width-12, height: 1))
        
        //set CornerRadius
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //set Text and Text Properties
        label.text = "Today`s record".localizeString()
        label.font = UIFont(name: "Poppins-Medium", size: 12)
        label.textColor = UIColor(named: "headerTxtColor")
        
        //set Seperator
        seprator.backgroundColor = UIColor(named: "sepratorColor")
        seprator.layer.opacity = 0.5
        
        view.backgroundColor = UIColor(named: "headerBgColor")
        view.addSubview(label)
        view.addSubview(seprator)
        
        if arrUserData.count == 0 {
            userActivityTableView.isScrollEnabled = false
            return UIView()
        } else {
            userActivityTableView.isScrollEnabled = true
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: nil) { (action, view, handler) in
            self.showAlert(index: indexPath.row)
        }
        editAction.backgroundColor = UIColor(named: "historyCellColor")
        editAction.image = UIImage(named: "ico_edit")
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (action, view, handler) in
            self.showDeleteCellAlert(index: indexPath.row)
        }
        deleteAction.backgroundColor = UIColor(named: "historyCellColor")
        deleteAction.image = UIImage(named: "ico_delete")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
