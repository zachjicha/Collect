//
//  Receipt+CoreDataProperties.swift
//  Collect
//
//  Created by Brian Thyfault on 7/17/19.
//  Copyright © 2019 The Collective. All rights reserved.
//
//

import Foundation
import CoreData


extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var receiptName: String?
    @NSManaged public var itemsOnReceipt: NSOrderedSet?
    @NSManaged public var receiptToPerson: NSSet?

}

// MARK: Generated accessors for itemsOnReceipt
extension Receipt {

    @objc(insertObject:inItemsOnReceiptAtIndex:)
    @NSManaged public func insertIntoItemsOnReceipt(_ value: ReceiptItems, at idx: Int)

    @objc(removeObjectFromItemsOnReceiptAtIndex:)
    @NSManaged public func removeFromItemsOnReceipt(at idx: Int)

    @objc(insertItemsOnReceipt:atIndexes:)
    @NSManaged public func insertIntoItemsOnReceipt(_ values: [ReceiptItems], at indexes: NSIndexSet)

    @objc(removeItemsOnReceiptAtIndexes:)
    @NSManaged public func removeFromItemsOnReceipt(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsOnReceiptAtIndex:withObject:)
    @NSManaged public func replaceItemsOnReceipt(at idx: Int, with value: ReceiptItems)

    @objc(replaceItemsOnReceiptAtIndexes:withItemsOnReceipt:)
    @NSManaged public func replaceItemsOnReceipt(at indexes: NSIndexSet, with values: [ReceiptItems])

    @objc(addItemsOnReceiptObject:)
    @NSManaged public func addToItemsOnReceipt(_ value: ReceiptItems)

    @objc(removeItemsOnReceiptObject:)
    @NSManaged public func removeFromItemsOnReceipt(_ value: ReceiptItems)

    @objc(addItemsOnReceipt:)
    @NSManaged public func addToItemsOnReceipt(_ values: NSOrderedSet)

    @objc(removeItemsOnReceipt:)
    @NSManaged public func removeFromItemsOnReceipt(_ values: NSOrderedSet)

}

// MARK: Generated accessors for receiptToPerson
extension Receipt {

    @objc(addReceiptToPersonObject:)
    @NSManaged public func addToReceiptToPerson(_ value: PeopleList)

    @objc(removeReceiptToPersonObject:)
    @NSManaged public func removeFromReceiptToPerson(_ value: PeopleList)

    @objc(addReceiptToPerson:)
    @NSManaged public func addToReceiptToPerson(_ values: NSSet)

    @objc(removeReceiptToPerson:)
    @NSManaged public func removeFromReceiptToPerson(_ values: NSSet)

}
