//
//  SelectNamesViewController.swift
//  Collect
//
//  Created by Brian Thyfault on 7/18/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class SelectNamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var receiptName: String = ""
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameSwitchCell", for: indexPath) as! NameSwitchesTableViewCell
        let person = peopleArray[indexPath.row]
        
        
        cell.nameLabel.text = person.nameOfPerson!
        
        //This is where we need to grab from storage if the person is
        //splitting the item. Instead of false use if they are splitting or not
        cell.switchToggle.setOn(false, animated: false)
        
        return cell
    }
   

}
