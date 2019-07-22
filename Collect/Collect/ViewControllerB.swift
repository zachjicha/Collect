//
//  ViewControllerB.swift
//  Collect
//
//  Created by Norris Chan on 7/14/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import SCLAlertView

 class ViewControllerB: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // creates an array for the list of names
    var recipient: [Names] = []
    var receiptName: String = ""
    var AllItems:[ReceiptItems] = []
    var peopleArray:[PeopleList] = []
    var moneyOwed:[Double] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // displays number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray.count
    }

    @IBAction func sharePressed(_ sender: Any) {
        
        //If there are no recipients, show an alert and cancel sharing
        if(peopleArray.count == 0) {
            SCLAlertView().showError("Share Error", subTitle: "You must enter recipients before sharing", colorStyle: 0xFF002A)
            return
        }
        
        var shareString = ""
        
        for (index, person) in peopleArray.enumerated() {
            
            //If the person owes no money, no need to tell them that
            if(moneyOwed[index] == 0) {
                continue
            }
            
            //Replace cost with each person's amount owed
            shareString += String(format: "%@: $%.2f\n", person.nameOfPerson!, moneyOwed[index])
        }
        
        //Remove the last newline character
        if(shareString.count > 0) {
            shareString.remove(at: shareString.index(before: shareString.endIndex))
        }
        
        if(shareString == "") {
            SCLAlertView().showError("Share Error", subTitle: "No recipients owe any money", colorStyle: 0xFF002A)
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        let person = peopleArray[indexPath.row]
        
        
        cell.textLabel!.text = person.nameOfPerson!
        //Set the right detail text to the amount owed for that person
        cell.detailTextLabel!.text = String(format: "$%.2f", moneyOwed[indexPath.row])
        
        return cell
    }
    
    
    func fetchPeople(receiptName: String)
    {
        //Fetches the specific data
        guard let peopleItems = PeopleList.FetchPeopleList(with: receiptName)
            //If data is not found, returns no data found
            else {
                print("Data Not Found")
                return
        }
        print("SUCCESS")
        peopleArray = peopleItems
        
        print(peopleArray.count)
    }
    
    func fetchData(receiptName: String) {
        //Fetches the specific data
        guard let receiptItemsObj = ReceiptItems.FetchReceiptItems(with: receiptName)
            //If data is not found, returns no data found
            else {
                print("Data Not Found")
                return
        }
        print("SUCCESS")
        AllItems = receiptItemsObj
    }
    
    func splitItems() {
        
        //Reset the array to have the same number of entries as people
        moneyOwed = []
        for _ in peopleArray {
            moneyOwed.append(0)
        }
        
        //Loop through each item in the receipt
        for item in AllItems {
            
            //Count how many people are splitting the item
            var numberOfSplitters = 0
            for person in peopleArray {
                if (item.CheckItemPeopleList(nameOfPerson: person.nameOfPerson!) == true) {
                    numberOfSplitters += 1
                }
            }
            
            //If no one is splitting, skip this item
            if(numberOfSplitters == 0) {
                continue
            }
            
            //Divide the split cost among each splitter
            for (index, person) in peopleArray.enumerated() {
                if (item.CheckItemPeopleList(nameOfPerson: person.nameOfPerson!) == true) {
                    moneyOwed[index] += (item.itemPrice + (Double(item.itemPrice) * Double(item.GetTaxPercent())))/Double(numberOfSplitters)
                }
            }
        }
    }
    
    @IBAction func addRecipient(_ sender: UIBarButtonItem) {
        // Custom alert view
        let alert = SCLAlertView()
        let name = alert.addTextField("Enter Recipient Name")
        alert.addButton("Add Recipient") {
            // If field is empty
            if (name.text == "") {
                SCLAlertView().showError("Receipt Name Error", subTitle: "You Must Enter a Recipient's name", colorStyle:0xFF002A)
                return
            }
            else {
                //Chakes to see if person already exists within the list of people (to prevent fetch errors)
                for people in self.peopleArray {
                    if (people.nameOfPerson == name.text) {
                        SCLAlertView().showError("Identical Name Already Exists", subTitle: "Please enter another name.", colorStyle:0xFF002A)
                        return
                    }
                }
                addPerson(nameOfPerson: name.text!, nameOfReceipt: self.receiptName)
                
                //Add an entry to money owed for the new person
                self.moneyOwed.append(0)
                
                self.fetchPeople(receiptName: self.receiptName)
                self.tableView.reloadData()
            }
        }
        alert.showEdit("Add a Recipient", subTitle: "Please Add a Recipient's Name", colorStyle:0xFF002A)
    }
    
    
    @objc func addMethod()
    {
        
        // Custom alert view
        let alert = SCLAlertView()
        let name = alert.addTextField("Enter Recipient Name")
        alert.addButton("Add Recipient") {
            // If field is empty
            if (name.text == "") {
                SCLAlertView().showError("Add Error", subTitle: "You Must Enter a Recipient's name", colorStyle:0xFF002A)
                return
            }
            else {
                //Chakes to see if person already exists within the list of people (to prevent fetch errors)
                for people in self.peopleArray {
                    if (people.nameOfPerson == name.text) {
                        SCLAlertView().showError("Identical Name Already Exists", subTitle: "Please enter another name.", colorStyle:0xFF002A)
                        return
                    }
                }
                addPerson(nameOfPerson: name.text!, nameOfReceipt: self.receiptName)
                
                //Add an entry to money owed for the new person
                self.moneyOwed.append(0)
                
                self.fetchPeople(receiptName: self.receiptName)
                self.tableView.reloadData()
            }
        }
        alert.showEdit("Add a Recipient", subTitle: "Please Add a Recipient's Name", colorStyle:0xFF002A)
    }
    
    // displays list
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMethod))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        navigationController?.navigationBar.tintColor = .red
        self.title = "Receipients"
        fetchPeople(receiptName: receiptName)
        fetchData(receiptName: receiptName)
        splitItems()
        self.tableView.reloadData()
    }
    
    //Called whenever the view appears, used for refreshing when popping off view controller stack
    override func viewDidAppear(_ animated: Bool) {
        //Refresh the view
        self.viewDidLoad()
    }
    
    //Override function for passing data from one ViewController to another
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue identifier set at segue properties in toolbar (right side)
        if segue.identifier == "ShowItemList" {
            
            let controller = segue.destination as! ReceiptItemViewController
            controller.receiptName = receiptName
            controller.peopleArray = peopleArray
            
        }/*
         if segue.identifier == "AddPeopleVC" {
         if let indexPath = self.tableView.indexPathForSelectedRow {
         //In Storyboard ItemListViewController, there is a global variable titled "receiptname".  This sends the receipt name to the ItemListViewController so it can load the items of that specific receipt
         let controller = segue.destination as! ViewControllerB
         controller.receiptName = AllReceipts[indexPath.row].receiptName!
         }
         }*/
    }
    
    //Function that adds the swipe to delete function to the receipt view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //Goes through all items to see if the person is within the list, then deletes them from every item
            for item in AllItems {
                //If name is found within item's payer list, it will be deleted/removed
                if (item.CheckItemPeopleList(nameOfPerson: peopleArray[indexPath.row].nameOfPerson!) == true) {
                    item.deletePayerOfItemRelationship(with: peopleArray[indexPath.row].nameOfPerson!)
                }
            }
            //Deletes the person from person list
            peopleArray[indexPath.row].deletePerson()
            viewDidLoad()
        }
    }
}

class Names {
    var names = ""
    convenience init(names2: String) {
        self.init()
        self.names = names2
    }
}
