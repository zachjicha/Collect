//
//  DebtCell.swift
//  Collect
//
//  Created by Norris Chan on 7/21/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class DebtCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var switchToggle: UISwitch!
    
    @IBOutlet weak var switchChange: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
