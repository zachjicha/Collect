//
//  ReceiptItems+CoreDataProperties.swift
//  Collect
//
//  Created by Harsh Karia on 7/16/19.
//  Copyright © 2019 The Collective. All rights reserved.
//
//

import Foundation
import CoreData


extension ReceiptItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReceiptItems> {
        return NSFetchRequest<ReceiptItems>(entityName: "ReceiptItems")
    }

    @NSManaged public var itemName: String?
    @NSManaged public var itemReceipt: Receipt?
    @NSManaged public var itemToPerson: People?

}
