//
//  PeopleListExtension.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/23/19.
//  Copyright © 2019 The Collective. All rights reserved.
//


/************************************************************************************
 Within this file are functions that manipulate the PeopleList entity.  This entity
 keeps track of the people who are associated with specific receipts.  The functions
 within this file are range from adding people to the PeopleList to modifying its
 attribues, all the way up to being able to delete and fetch either a single person
 or an entire PeopleList associated with a specific receipt
 *************************************************************************************/


import Foundation
import CoreData
import UIKit

extension PeopleList
{
    // Gets the list of people associated with a given receipt name
    class func FetchPeopleList(with receiptName: String) -> [PeopleList]? {
        // Array of all people
        var allPeople : [PeopleList] = []
        //Defines context to be used to save to core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //Creates fetch request for all items
        let myFetch:NSFetchRequest<PeopleList> = PeopleList.fetchRequest()
        // Name of relationship to other entity -> Attribute name we want within that entity
        let myPredicate = NSPredicate(format: "personToReceipt.receiptName == %@", receiptName)
        myFetch.predicate = myPredicate
        do {
            let result = try context.fetch(myFetch)
            allPeople = result
        }
        catch {
            print(error)
        }
        return allPeople
    }
    
    //Function that checks to see if the person has paid
    func CheckPaymentStatus () -> Bool {
        //Returns the Boolean value of if they've paid or not
        return self.hasPaid
    }
    //Function that changes the table row status to Paid
    func ChangePaymentStatus() {
        //Checks if hasPaid status is paid or not to change/flip it to the correct status
        if (self.hasPaid == true) {
            self.hasPaid = false
        }
        else {
            self.hasPaid = true
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //A function that deletes the person form the list
    func deletePerson() {
        //Does the actual deleting
        context.delete(self)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
