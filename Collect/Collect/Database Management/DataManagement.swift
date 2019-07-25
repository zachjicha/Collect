//
//  DataManagement.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//


/************************************************************************************
 Within this file are functions that use ReceiptEntity, ReceiptItems, and People List
 entity in order to manipulate core data.
 *************************************************************************************/


import Foundation
import CoreData
import UIKit

//Declares Item struct
struct Item : Codable
{
    let itemName : String?
    let totalAmount: Double?
}


//Global context variable (use for fetching and storing data)
var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//Function for saving full receipt Data using
//(not part of the Receipt and ReceiptItems Extension)
//Takes name of receipt and an item struct array as inputs
func SaveAllReceiptData (NameOfReceipt: String, Items: [Item], taxPercent: Double, imageData: UIImage) {
    
    //context variable for fetching and storing data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Creates Receipt Entity Context
    let ReceiptName = Receipt(context: context)
    ReceiptName.receiptName = NameOfReceipt
    ReceiptName.taxPercent = taxPercent
    
    
    
    //Converts the UI Image to NSData
    let imageBinData = imageData.pngData()
    
    //Saves the image into core data
    ReceiptName.receiptImage = imageBinData as NSData?
    
    //Creates an array that keeps track of what has already gone into the Receipt Entity
    var DuplicateItemChecker: [String] = []
    
    //Loops through all items to create a relaitonsip with the receipt
    for item in Items {
        //Creates a ReceiptItem entity context
        let itemsInReceipt = ReceiptItems(context: context)
        //variable that keeps track of duplicate item count
        var duplicateInteger = 0
        //For loop that goes through array and checks for name duplicate
        for DuplicateItemName in DuplicateItemChecker {
            //If similar item is found, duplicateInteger incremented by 1
            if (DuplicateItemName == item.itemName) {
                duplicateInteger = duplicateInteger + 1
            }
        }
        
        //Adds original name to Duplicate checker array to take into account 2+ duplicates
        DuplicateItemChecker.append(item.itemName!)
        
        //Checks if item already exists within the receipt
        if(duplicateInteger > 0) {
            //Creates new item name with "#x" added to it where x = # of duplicate items+1
            let newItemName = String(format:"#%d: %@", duplicateInteger+1, item.itemName!)
            itemsInReceipt.itemName = newItemName
        }else { //else occurs if no duplicate item is found
            itemsInReceipt.itemName = item.itemName
        }
        //Adds the rest of the required variables into ReceiptItem Entity
        itemsInReceipt.itemPrice = item.totalAmount!
        ReceiptName.addToItemsOnReceipt(itemsInReceipt)
    }
    
    //Clear duplicate items array
    DuplicateItemChecker = []   //sets it as an empty
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

//Function that fetches image data based on receipt name (returns a UIImage)
func fetchImageData(receiptName: String) -> UIImage {
    //Fetches the receiptData from receipt
    let receiptData: Receipt = Receipt.FetchData(with: receiptName)!
    
    //gets image bin data and converts it to UIImage
    let imgUIData = receiptData.receiptImage! as Data
    
    //Converts image binary data to a UIImage
    let imgData = UIImage(data: imgUIData)
    
    return imgData!
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
    personContext.hasPaid = false
    
    
    guard let receipt = Receipt.FetchData(with: nameOfReceipt) else { return }
    receipt.addToReceiptToPerson(personContext)
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
