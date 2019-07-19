//
//  NameSwitchesTableViewCell.swift
//  Collect
//
//  Created by Brian Thyfault on 7/18/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class NameSwitchesTableViewCell: UITableViewCell {

    @IBOutlet weak var switchToggle: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
