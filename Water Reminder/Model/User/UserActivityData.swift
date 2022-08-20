//
//  UserActivityData.swift
//  Water Reminder
//
//  Created by macOS on 30/06/22.
//

import Foundation
import RealmSwift

//MARK: - UserActivityData
class UserActivityData: Object {
    @objc dynamic var date: Date!
    @objc dynamic var dateInString: String = ""
    @objc dynamic var timeInString: String = ""
    @objc dynamic var drinkedWater: Float = 0
}
