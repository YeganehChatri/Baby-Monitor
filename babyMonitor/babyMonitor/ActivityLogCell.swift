//
//  ActivityLogCell.swift
//  babyMonitor
//
//  Created by yeganeh on 5/25/17.
//  Copyright © 2017 yeganeh. All rights reserved.
//

import UIKit

class ActivityLogCell: UITableViewCell {
    
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
