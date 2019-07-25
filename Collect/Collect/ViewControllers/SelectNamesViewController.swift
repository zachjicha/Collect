//
//  SelectNamesViewController.swift
//  Collect
//
//  Created by Brian Thyfault on 7/18/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class SelectNamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Var that keeps track of receipt name
    var receiptName: String = ""
    
    //Var that keeps track of item name
    var itemName: String = ""
    
    var peopleArray : [PeopleList] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPeople(receiptName: receiptName)
        self.tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = itemName
    }
    
    
    //Function that fetches people list based on given receipt name
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
    
    
    // displays number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray.count
    }
    
    
    //Sets up cell properties and what they display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameSwitchCell", for: indexPath) /*as! NameSwitchesTableViewCell*/
        let person = peopleArray[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.red
        cell.textLabel!.text = person.nameOfPerson!
        
        //Sets up cell switch that appears on the ride side of each cell
        let cellSwitch = UISwitch(frame: .zero)
        cellSwitch.onTintColor = UIColor.red
        
        //Creates an ReceiptItem context
        var item = ReceiptItems(context: context)
        item = ReceiptItems.FetchSingleReceiptItem(with: receiptName, with: itemName)
        
        //If statement to check and see if the name is within the list of ppl associated with the item
        if (item.CheckItemPeopleList(nameOfPerson: person.nameOfPerson!) == true) {
            cellSwitch.setOn(true, animated: true)
        }
        else {
            cellSwitch.setOn(false, animated: true)
        }
        //Sets the cell switch properties
        cellSwitch.tag = indexPath.row // for detect which row switch Changed
        cellSwitch.addTarget(self, action: #selector(self.SwitchToggleDelection(_:)), for: .valueChanged)
        cell.accessoryView = cellSwitch
        
        return cell
    }
    
    
    //Function used/called when a switch is toggled
    @objc func SwitchToggleDelection(_ sender : UISwitch!){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Creates item variable for the specific item to be changed/modified (in terms of relationship)
        var item = ReceiptItems(context: context)
        item = ReceiptItems.FetchSingleReceiptItem(with: receiptName, with: itemName)
        //print(item)
        
        //if On, add the person to the list of ppl associated with the items
        if (sender.isOn == true) {
            print("Detected ON for item: " + itemName + " for " + peopleArray[sender.tag].nameOfPerson!)
            
            //Converts PeopleList to PeoplePaying
            let personPaying = PeoplePaying(context: context)
            personPaying.nameOfPayer = peopleArray[sender.tag].nameOfPerson
            
            //Adds person as a payer for the item
            item.addToPayerOfItem(personPaying)
        }
        //If off, remove the person from the list of ppl associated with the items
        else {
            print("DETECTED OFF for itm: " + itemName + " for " + peopleArray[sender.tag].nameOfPerson!)
            
            //Retrives ReceiptItem entity for specified item
            let item = ReceiptItems.FetchSingleReceiptItem(with: receiptName, with: itemName)
            
            //Removes person as a payer for the item
            item.deletePayerOfItemRelationship(with: peopleArray[sender.tag].nameOfPerson!)
        }
        //saves data to core data
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
