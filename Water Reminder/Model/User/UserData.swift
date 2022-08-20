//
//  UserData.swift
//  Water Reminder
//
//  Created by macOS on 27/06/22.
//

import Foundation
import RealmSwift

//MARK: - UserData
class UserData: Object {
    @objc dynamic var gender: String = ""
    @objc dynamic var weight: Int = 0
    @objc dynamic var unit: String = ""
    @objc dynamic var wakeUpTimeInString: String = ""
    @objc dynamic var bedTimeInString: String = ""
    @objc dynamic var wakeUpTime: Date!
    @objc dynamic var bedTime: Date!
}
