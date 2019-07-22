//
//  ReceiptItems+CoreDataProperties.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/19/19.
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
    @NSManaged public var itemPrice: Double
    @NSManaged public var itemReceipt: Receipt?
    @NSManaged public var itemToPerson: NSSet?
    @NSManaged public var payerOfItem: NSSet?

}

// MARK: Generated accessors for itemToPerson
extension ReceiptItems {

    @objc(addItemToPersonObject:)
    @NSManaged public func addToItemToPerson(_ value: PeopleList)

    @objc(removeItemToPersonObject:)
    @NSManaged public func removeFromItemToPerson(_ value: PeopleList)

    @objc(addItemToPerson:)
    @NSManaged public func addToItemToPerson(_ values: NSSet)

    @objc(removeItemToPerson:)
    @NSManaged public func removeFromItemToPerson(_ values: NSSet)

}

// MARK: Generated accessors for payerOfItem
extension ReceiptItems {

    @objc(addPayerOfItemObject:)
    @NSManaged public func addToPayerOfItem(_ value: PeoplePaying)

    @objc(removePayerOfItemObject:)
    @NSManaged public func removeFromPayerOfItem(_ value: PeoplePaying)

    @objc(addPayerOfItem:)
    @NSManaged public func addToPayerOfItem(_ values: NSSet)

    @objc(removePayerOfItem:)
    @NSManaged public func removeFromPayerOfItem(_ values: NSSet)

}
