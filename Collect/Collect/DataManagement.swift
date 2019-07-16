//
//  DataManagement.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//Global context variable (use for fetching and storing data)
var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//Extension for the receipt entity
extension Receipt {
    
    //Function that returns Receipt data through the use of the receipt name (1 receipt only) [USED FOR DELETING]
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
    
    //Class function that returns an array of Receipt Entities
    //This strictly returns strings (not other data)
    class func FetchListOfReceipts () -> [Receipt]? {
        
        //variable to return (itialized as empty)
        var AllReceipts:[Receipt] = []
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            AllReceipts = try context.fetch(Receipt.fetchRequest())
            let fetchSet = Set(AllReceipts)
            print(fetchSet)
            
        } catch{
            print(error)
        }
        return AllReceipts
    }
    
    
    //A function that deletes the receipt
    func deleteReceipt() {
        //Does the actual deleting
        context.delete(self)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}

//Creates an extension for receipt items
extension ReceiptItems {
    
    //Function that fetches the receipt items based on the receipt name given and returns the receipt item entity array
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
            print(result.count)
            AllItems = result
        }
        catch {
            print(error)
        }
        return AllItems
    }
}


//Function for saving data using core data
//Will mainly be used for saving receipt references
func SaveReceiptData (NameOfReceipt: String/*, ItemCost: Double*/) {
    
    //Creates variable for Container access
    let CreateReceipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: context)
    CreateReceipt.setValue(NameOfReceipt, forKey: "receiptName")
    
    //save to container/core data
    do {
        try context.save()
    } catch {
        print(error)
    }
}

//Function for saving full receipt Data using
//(not part of the Receipt and ReceiptItems Extension)
//Takes name of receipt and an item struct array as inputs
func SaveAllReceiptData (NameOfReceipt: String, Items: [Item]) {
    
    //context variable for fetching and storing data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Creates Receipt Entity Context
    let ReceiptName = Receipt(context: context)
    ReceiptName.receiptName = NameOfReceipt
    
    //Loops through all items to create a relaitonsip with the receipt
    for item in Items {
        let itemsInReceipt = ReceiptItems(context: context)
        itemsInReceipt.itemName = item.itemName
        itemsInReceipt.itemPrice = item.totalAmount!
        print("Item: " + itemsInReceipt.itemName! + "\nPrice: " + String(itemsInReceipt.itemPrice))
        ReceiptName.addToItemsOnReceipt(itemsInReceipt)
    }
    //save to container/core data
    do {
        try context.save()
    } catch {
        print(error)
    }
}


//Function that will delete the specified receipt (It will also delete item data)
func DeleteReceiptData (NameOfItem: String) {
    
    //delete specific data
    guard let item = Receipt.FetchData(with: NameOfItem) else { return }
    item.deleteReceipt()
}

//Checks if receipt name already exists within core database
//Return results:  True - The name already exists | false - name does not exist
func CheckDuplicity (receiptName: String) -> Bool {
    
    let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
    
    //NSPredicate to specify arguments for what to look up
    request.predicate = NSPredicate(format: "receiptName = %@", receiptName)
    
    //Attempts to find requested attribute/entities
    do {
        let result = try context.fetch(request)
        let isEqual = (receiptName == result.first?.receiptName)
        return isEqual //returns a boolean
        
    } catch let error {
        print(error.localizedDescription)
        return false
    }
        return true //place holder so xcode wont complain (code will never get to this line of code during execution)
}


//DELETE LATER: Function used to dismiss keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
