//
//  PeopleList+CoreDataProperties.swift
//  
//
//  Created by Harsh Karia on 3/5/20.
//
//

import Foundation
import CoreData


extension PeopleList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PeopleList> {
        return NSFetchRequest<PeopleList>(entityName: "PeopleList")
    }

    @NSManaged public var hasPaid: Bool
    @NSManaged public var nameOfPerson: String?
    @NSManaged public var personToItems: ReceiptItems?
    @NSManaged public var personToReceipt: Receipt?

}
