//
//  TotalDrinkedWater.swift
//  Water Reminder
//
//  Created by macOS on 07/07/22.
//

import Foundation
import RealmSwift

//MARK: - TotalDrinkedWater
class TotalDrinkedWater: Object {
    @objc dynamic var date: Date!
    @objc dynamic var dateInString: String = ""
    @objc dynamic var totalDrinkedWater: Float = 0
}
