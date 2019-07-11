//
//  Item.swift
//  CollectApp
//
//  Created by Brian Thyfault on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import Foundation

class Item {
    
    var itemName:String?
    var itemCost:Double?
    var isNameEnabled:[Bool]?
    
    init(itemName: String, itemCost: Double) {
        
        //Init memeber fields
        self.itemName = itemName
        self.itemCost = itemCost
        
        //Append 6 falses
        for index in 0...5 {
            isNameEnabled?.append(false)
        }
        
    }
    
}
