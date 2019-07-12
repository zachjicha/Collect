//
//  Receipt+CoreDataProperties.swift
//  
//
//  Created by Rizzian Tuazon on 7/11/19.
//
//

import Foundation
import CoreData

//Creates variable/ref for container (Data Storage management)
var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }
    
    //Alternate function that fetches specific data using the extension
    class func FetchData (with itemName: String) -> Receipt? {
        let request = Receipt.fetchRequest()
        
        //NSPredicate to specify arguments for what to look up
        let predicate = NSPredicate(format: "itemName = %@", itemName)
        request.predicate = predicate
        
        //Attempts to find requested attribute/entities
        do {
            let tasks = try context.fetch(request)
            return tasks.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //Function that deletes data
    //A function that deletes the receipt (it's self)
    func deleteReceipt() {
        context.delete(self)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    @NSManaged public var itemName: String?
    @NSManaged public var receiptNum: Int16

}



