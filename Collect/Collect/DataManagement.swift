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
    
    //***********************DO NOT USE THESE FUNCTIONS INDIVUDUALLY**********************************
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
    
    //***************************************************************************************************
    
    
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
}

//Creates an extension for receipt items
extension ReceiptItems {
    
    //Function that returns a specific Item entity
    class func FetchSingleReceiptItem(with receiptName: String, with itemName: String) -> ReceiptItems {
        
        var ReceiptItem:[ReceiptItems] = []
        
        //Fetch 1 item within the a list of receipts
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Creates fetch request for all items
        let myFetch:NSFetchRequest<ReceiptItems> = ReceiptItems.fetchRequest()
        let myPredicate = NSPredicate(format: "itemReceipt.receiptName == %@", receiptName)
        myFetch.predicate = myPredicate
        
        //Does the search and filters results to a single item
        do {
            let result = try context.fetch(myFetch)
            print(result.count)
            let filteredresults = result.filter {
                $0.itemName!.contains(itemName)
            }
            ReceiptItem = filteredresults
        }
        catch {
            print(error)
        }
        return ReceiptItem.first!
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
            print(result.count)
            AllItems = result
        }
        catch {
            print(error)
        }
        return AllItems
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
    
    //Funciton that returns a list of payer of a specific item (returns an NSSet)
    /*func getPayerList () -> String {
        let payerList:[PeoplePaying] = self.payerOfItem!
        
        
        
        
        
    }*/
    
    //Function that gets the tax % of the receipt that this item is related to
    func GetTaxPercent () -> Double {
        //Retrieves receipt tax percent
        let receiptTaxPercent = (self.itemReceipt)?.taxPercent
        return receiptTaxPercent!
    }
}

extension PeopleList
{
    // Gets the list of people associated with a given receipt name
    class func FetchPeopleList(with receiptName: String) -> [PeopleList]? {
        // Array of all people
        var allPeople : [PeopleList] = []
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Creates fetch request for all items
        let myFetch:NSFetchRequest<PeopleList> = PeopleList.fetchRequest()
        // Name of relationship to other entity -> Attribute name we want within that entity
        let myPredicate = NSPredicate(format: "personToReceipt.receiptName == %@", receiptName)
        myFetch.predicate = myPredicate
        
        do {
            let result = try context.fetch(myFetch)
            print("People Fetched", result.count)
            allPeople = result
        }
        catch {
            print(error)
        }
        return allPeople
        
    }
}

//Function for saving data using core data
//Will mainly be used for saving receipt references
//*************THIS FUNCTION IS TO BE DELETED*****************
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
func SaveAllReceiptData (NameOfReceipt: String, Items: [Item], taxPercent: Double) {
    
    //context variable for fetching and storing data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Creates Receipt Entity Context
    let ReceiptName = Receipt(context: context)
    ReceiptName.receiptName = NameOfReceipt
    ReceiptName.taxPercent = taxPercent
    
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

//Function that updates the receipt data (for midifications)
//This is limited to receipt name so far
func updateReceiptData (receiptName: String,newReceiptName: String) {
    guard let item = Receipt.FetchData(with: receiptName) else { return }
    item.updateData(with: newReceiptName)
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
        
    } catch {
        print(error.localizedDescription)
        return false
    }
    return true //place holder so xcode wont complain (code will never get to this line of code during execution)
}

func addPerson(nameOfPerson : String, nameOfReceipt : String)
{
    
    //context variable for fetching and storing data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Creates Person Entity Context
    let personContext = PeopleList(context: context)
    personContext.nameOfPerson = nameOfPerson
    
    
    guard let receipt = Receipt.FetchData(with: nameOfReceipt) else { return }
    receipt.addToReceiptToPerson(personContext)
    print("ADDING ", nameOfPerson)
    print("Rec. Name: ", nameOfReceipt)
    do {
        try context.save()
    } catch {
        print(error)
    }
}

//Allows for the UIViewController to dismiss the keyboard if we tap anywhere else in the screen
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