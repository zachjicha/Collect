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
    
    // displays number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameSwitchCell", for: indexPath) /*as! NameSwitchesTableViewCell*/
        let person = peopleArray[indexPath.row]
        
        
        cell.textLabel!.text = person.nameOfPerson!
        
        //This is where we need to grab from storage if the person is
        //splitting the item. Instead of false use if they are splitting or not
        //cell.switchToggle.setOn(false, animated: false)
        //cell.switchToggle.
        
        
        let cellSwitch = UISwitch(frame: .zero)
        
        //If statement to check and see if the name is within the list of ppl associated with the item
        
        cellSwitch.setOn(false, animated: true)
        cellSwitch.tag = indexPath.row // for detect which row switch Changed
        cellSwitch.addTarget(self, action: #selector(self.SwitchToggleDelection(_:)), for: .valueChanged)
        cell.accessoryView = cellSwitch
        
        
        
        return cell
    }
    
    //Function that detects if the switches are toggled or not
    @objc func SwitchToggleDelection(_ sender : UISwitch!){
        //if On, add the person to the list of ppl associated with the items
        if (sender.isOn == true) {
            print("Detected ON for item: " + itemName + " for " + peopleArray[sender.tag].nameOfPerson!)
        }
        //If off, remove the person from the list of ppl associated with the items
        else {
            print("DETECTED OFF for itm: " + itemName + " for " + peopleArray[sender.tag].nameOfPerson!)
        }
        
    }
   

}
