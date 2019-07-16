//
//  People+CoreDataProperties.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/16/19.
//  Copyright © 2019 The Collective. All rights reserved.
//
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var personName: String?
    @NSManaged public var personToItem: ReceiptItems?
    @NSManaged public var mainReceiptToPeople: Receipt?

}
