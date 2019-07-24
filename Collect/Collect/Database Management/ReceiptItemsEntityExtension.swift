//
//  ReceiptItemsEntityExtension.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/23/19.
//  Copyright © 2019 The Collective. All rights reserved.
//


/************************************************************************************
 Within this file are functions that manipulate the ReceiptItems Entity.  ReceiptItems
 entity keeps track of the receipt items of each receipts that are scanned.  The
 functions within this file ranges from being able to save receipt items to receipts,
 to being able to delete receipts, all the way up to being able to manipulate
 individual receipt attributes.
 *************************************************************************************/

import Foundation
import CoreData
import UIKit


//Creates an extension for receipt items
extension ReceiptItems {
    
    //Function that returns a specific Item entity
    class func FetchSingleReceiptItem(with receiptName: String, with itemName: String) -> ReceiptItems {
        //Fetch 1 item within the a list of receipts
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var receiptItemToReturn: ReceiptItems = ReceiptItems(context: context)
        
        //Creates fetch request for all items
        let myFetch:NSFetchRequest<ReceiptItems> = ReceiptItems.fetchRequest()
        let myPredicate = NSPredicate(format: "itemReceipt.receiptName == %@", receiptName)
        myFetch.predicate = myPredicate
        
        //Does the search and filters results to a single item
        do {
            let result = try context.fetch(myFetch)
            //For loops that loops through NSList
            for receiptItem in result {
                if (receiptItem.itemName == itemName) { //item name will always be found
                    receiptItemToReturn = receiptItem
                    continue
                }
            }
        }
        catch {
            print(error)
        }
        return receiptItemToReturn
    }
    
    //Function that fetches the receipt items based on the receipt name given and returns the receipt item entity array
    //Returns an array of ReceiptItems
    class func FetchReceiptItems(with receiptName: String) -> [ReceiptItems]? {
        
        var AllItems:[ReceiptItems] = []
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Creates fetch request for all items
        let myFetch:NSFetchRequest<ReceiptItems> = ReceiptItems.fetchRequest()
        let myPredicate = NSPredicate(format: "itemReceipt.receiptName == %@", receiptName)
        myFetch.predicate = myPredicate
        
        //Does the actual fetching of data
        do {
            let result = try context.fetch(myFetch)
            AllItems = result
        }
        catch {
            print(error)
        }
        return AllItems
    }
    
    
    //Function that checks to see if the item name already exists within the receipt.
    //if it does, returns the number of duplicate names in the list
    //if it doesn't returns a zero
    func CheckForDuplicateItemName(itemName: String) -> Int {
        var DuplicateItems: [ReceiptItems] = []
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Creates fetch request for all items
        let myFetch:NSFetchRequest<ReceiptItems> = ReceiptItems.fetchRequest()
        let myPredicate = NSPredicate(format: "itemName == %@", itemName)
        myFetch.predicate = myPredicate
        
        //Fetches the data
        //Does the actual fetching of data
        do {
            let result = try context.fetch(myFetch)
            DuplicateItems = result
        }
        catch {
            print(error)
        }
        return DuplicateItems.count
        
    }
    
    
    //Function that deletes a specific entity from a relationship
    func deletePayerOfItemRelationship(with nameOfPerson: String) {
        
        //Accesses the relationship pertaining to the people who will pay for this item
        let itemPayerList: NSSet = self.payerOfItem!
        
        //Creates NSPredicate for to look for the person to delete that is associated with this item
        let fetchPayerPredicate = NSPredicate(format: "nameOfPayer == %@", nameOfPerson)
        
        //Filters the payer list to pinpoint the single person we need to delete
        let payer = itemPayerList.filtered(using: fetchPayerPredicate) as NSSet
        
        //Fetches the item to be whose relationship will be removed
        self.removeFromPayerOfItem(payer)
    }
    
    
    //Function that checks to see if a person is in a certain item's people list
    func CheckItemPeopleList(nameOfPerson: String) -> Bool{
        
        //Accesses the relationship pertaining to the people who will pay for this item
        let itemPayerList: NSSet = self.payerOfItem!
        
        //Creates NSPredicate for to look for the person to delete that is associated with this item
        let fetchPayerPredicate = NSPredicate(format: "nameOfPayer == %@", nameOfPerson)
        
        //Filters the payer list to pinpoint the single person we need to delete
        let payer = itemPayerList.filtered(using: fetchPayerPredicate) as NSSet
        
        if (payer.count > 0) {
            return true //returns true if name already exists within the list
        }
        else {
            return false //returns false if name does not exist within the list
        }
    }
    
    //function that updates the cost and/or the item name
    func updateItemData (newItemName: String, newItemPrice: Double) {
        //Changes the itemPrice to be the inputted item price
        self.itemName = newItemName
        self.itemPrice = newItemPrice
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //A function that deletes this item from the list
    func deleteItem() {
        //Does the actual deleting
        context.delete(self)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //Function that gets the tax % of the receipt that this item is related to
    func GetTaxPercent () -> Double {
        //Retrieves receipt tax percent
        let receiptTaxPercent = (self.itemReceipt)?.taxPercent
        return receiptTaxPercent!
    }
}
