//
//  ReceiptEntityExtension.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/23/19.
//  Copyright © 2019 The Collective. All rights reserved.
//


/************************************************************************************
Within this file are functions that manipulate the Receipt Entity.  The receipt entity
 keeps track of all the receipts that are scanned and acts as the parent entity for
 all ReceiptItems and PeopleLists.  The functions within this file ranges from
 saving receipts to modifying receipts to deleting receipts to fetching necessary
 data required for the application to work as a whole.
*************************************************************************************/


import Foundation
import CoreData
import UIKit


//Extension for the receipt entity
extension Receipt {

    //Function that returns Receipt data through the use of the receipt name (1 receipt only)
    class func FetchData (with receiptName: String) -> Receipt? {
        let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        
        //NSPredicate to specify arguments for what to look up
        request.predicate = NSPredicate(format: "receiptName = %@", receiptName)
        
        //Attempts to find requested attribute/entities
        do {
            let receipts = try context.fetch(request)
            return receipts.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //A function that deletes the receipt
    func deleteReceipt() {
        //Does the actual deleting
        context.delete(self)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    // update change name of the receipt
    func updateData(with name: String) {
        self.receiptName = name
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //Class function that returns an array of Receipt Entities
    class func FetchListOfReceipts () -> [Receipt]? {
        
        //variable to return (itialized as empty)
        var AllReceipts:[Receipt] = []
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            AllReceipts = try context.fetch(Receipt.fetchRequest())
        } catch{
            print(error)
        }
        return AllReceipts
    }
    
    //Function that deletes a specific person from PeopleList that is associated with this receipt
    func DeletePersonFromReceipt (nameOfPerson: String) {
        let request: NSFetchRequest<PeopleList> = PeopleList.fetchRequest()
        
        //NSPredicate to specify arguments for what to look up
        request.predicate = NSPredicate(format: "receiptToPerson.nameOfPerson = %@", nameOfPerson)
        
        //Attempts to find requested attribute/entities
        do {
            let personToDelete = try context.fetch(request)
            personToDelete.first!.deletePerson()
        } catch {
            print(error)
        }
        
    }
    
}
