//
//  SettingCell.swift
//  babyMonitor
//
//  Created by yeganeh on 5/30/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var switchOnOff: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
