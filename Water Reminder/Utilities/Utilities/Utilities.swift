//
//  Utilities.swift
//  Water Reminder
//
//  Created by macOS on 11/07/22.
//

import Foundation

//MARK: - Varibles
public var weekDayInHindi = ""
public var monthInHindi = ""
public var dateInHindi = ""

//MARK: - Set Weekday
func setWeekday() {
    let weekday = Calendar.current.component(.weekday, from: .now)
    let arrWeekDaysInHindi: [String] = ["रविवार", "सोमवार", "मंगलवार", "बुधवार", "गुरुवार", "शुक्रवार", "शनिवार"]
    weekDayInHindi = arrWeekDaysInHindi[weekday-1]
}

//MARK: - Set Day
func setDate() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    let date = dateFormatter.string(from: .now)
    let arrDatesInHindi: [String] = ["१", "२", "३", "४", "५", "६", "७", "८", "९", "१॰", "११", "१२", "१३", "१४", "१५", "१६", "१७", "१८", "१९", "२॰", "२१", "२२", "२३", "२४", "२५", "२६", "२७", "२८", "२९", "३॰", "३१"]
    dateInHindi = arrDatesInHindi[(Int(date) ?? 0) - 1]
}

//MARK: - Set Month
func setMonth() {
    let month = Calendar.current.component(.month, from: .now)
    let arrMonthInHindi: [String] = ["जनवरी", "फरवरी", "मार्च", "अप्रैल", "मई", "जून", "जुलाई", "अगस्त", "सितम्बर", "अक्टूबर", "नवम्बर", "दिसम्बर"]
    monthInHindi = arrMonthInHindi[month-1]
}

//MARK: - Localize String
extension String {
    func localizeString() -> String {
        let selected = UserDefaults.standard.string(forKey: kLanguage) ?? "en"
        let path = Bundle.main.path(forResource: selected, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
