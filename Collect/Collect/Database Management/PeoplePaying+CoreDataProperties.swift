//
//  PeoplePaying+CoreDataProperties.swift
//  
//
//  Created by Harsh Karia on 3/5/20.
//
//

import Foundation
import CoreData


extension PeoplePaying {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PeoplePaying> {
        return NSFetchRequest<PeoplePaying>(entityName: "PeoplePaying")
    }

    @NSManaged public var nameOfPayer: String?
    @NSManaged public var itemToPayFor: ReceiptItems?

}
