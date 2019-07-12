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
    //Alternate function that fetches specific data using the extension
    class func FetchData (with itemName: String) -> Receipt? {
        //let request = Receipt.fetchRequest()
        let request: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        
        //NSPredicate to specify arguments for what to look up
        //let predicate = NSPredicate(format: "itemName = %@", itemName)
        request.predicate = NSPredicate(format: "itemName = %@", itemName)
        
        //Attempts to find requested attribute/entities
        do {
            let tasks = try context.fetch(request)
            return tasks.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //A function that deletes the receipt
    func deleteReceipt() {
        //let item = Receipt.FetchData(with: itemName)
        //Does the actual deleting
        context.delete(self)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}


//Function for saving data using core data
//Will mainly be used for saving receipt references
func SaveReceiptData (NameOfItem: String/*, ItemCost: Double*/) {
    
    //Creates variable for Container access
    let CreateReceipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: context)
    CreateReceipt.setValue(NameOfItem, forKey: "itemName")
    
    //save to container/core data
    do {
        try context.save()
    } catch {
        print(error)
    }
}

//Function that will delete the specified data
func DeleteReceiptData (NameOfItem: String) {
    
    //delete specific data
    guard let item = Receipt.FetchData(with: NameOfItem) else { return }
    item.deleteReceipt()
}


//DELETE LATER: Function used to dismiss keyboard
// Put this piece of code anywhere you like
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
