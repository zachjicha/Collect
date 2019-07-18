//
//  Item.swift
//  CollectApp
//
//  Created by Brian Thyfault on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import Foundation

class ReceiptItem {
    
    var itemName:String
    var itemCost:Double
    var itemSplitters:[String]? = []
    
    init(itemName: String, itemCost: Double) {
        
        //Init memeber fields
        self.itemName = itemName
        self.itemCost = itemCost
        
    }
    
}
