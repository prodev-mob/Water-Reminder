//
//  SettingTableViewCell.swift
//  Water Reminder
//
//  Created by macOS on 04/07/22.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    //MARK: - LifeCycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
