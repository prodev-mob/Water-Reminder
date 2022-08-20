//
//  UserActivityTableViewCell.swift
//  Water Reminder
//
//  Created by macOS on 30/06/22.
//

import UIKit

class UserActivityTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var drinkedWaterLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: - LifeCycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}
