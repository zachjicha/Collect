//
//  PeopleList+CoreDataProperties.swift
//  Collect
//
//  Created by Harsh Karia on 7/16/19.
//  Copyright © 2019 The Collective. All rights reserved.
//
//

import Foundation
import CoreData


extension PeopleList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PeopleList> {
        return NSFetchRequest<PeopleList>(entityName: "PeopleList")
    }

    @NSManaged public var nameOfPerson: String?
    @NSManaged public var personToReceipt: Receipt?
    @NSManaged public var personToItems: ReceiptItems?

}
