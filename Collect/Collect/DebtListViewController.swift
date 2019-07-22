//
//  DebtListViewController.swift
//  Collect
//
//  Created by Norris Chan on 7/21/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import CoreData

class DebtListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var peopleArray: [PeopleList] = []
    var receiptName: String = ""
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPeople(receiptName: receiptName)
        print("testing debt list receipt: " + receiptName)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebtCell", for: indexPath)
        let person = peopleArray[indexPath.row]
        
        cell.textLabel!.text = person.nameOfPerson!
        
        
        
        
        return cell
        
    }

    
}
