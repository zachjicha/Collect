//
//  ItemTableCell.swift
//  CollectApp
//
//  Created by Brian Thyfault on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class ItemTableCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var nameSegment: MultiSelectSegmentedControl!
    
    func setItemName(recepitItem: ReceiptItem) {
        itemLabel.text = recepitItem.itemName
        
    }
    
    func setItemGroup(splittingGroup: [String]) {
        nameSegment.removeAllSegments()
        
        for index in 0...splittingGroup.count - 1 {
            nameSegment.insertSegment(withTitle: splittingGroup[index], at: index, animated: false)
        }
        
    }

}
