//
//  ItemTableCell.swift
//  CollectApp
//
//  Created by Brian Thyfault on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class ItemTableCell: UITableViewCell {
    @IBOutlet weak var nameSegment: UISegmentedControl!
    @IBOutlet weak var text: UILabel!
    
    
    func setCell(segmentControl: [Bool], text: String) {
        for (index, isNameEnabled) in segmentControl.enumerated() {
            nameSegment.setEnabled(isNameEnabled, index)
        }
    }

}
