//
//  ReceiptsViewController.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/10/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import CoreData

class ReceiptsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var AllReceipts:[Receipt] = []  //Array of receipts
    var receiptToOpen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up table view
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Receipts"
        
        //Fetches data needed to be loaded into table view
        self.FetchData()
        self.tableView.reloadData()
    }
    
    //Override function for passing data from one ViewController to another
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue identifier set at segue properties in toolbar (right side)
        if segue.identifier == "ShowReceiptItems" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //In Storyboard ItemListViewController, there is a global variable titled "receiptname".  This sends the receipt name to the ItemListViewController so it can load the items of that specific receipt
                let controller = segue.destination as! ItemListViewController
                controller.receiptname = AllReceipts[indexPath.row].receiptName!
            }
        }
        if segue.identifier == "AddPeopleVC" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //In Storyboard ItemListViewController, there is a global variable titled "receiptname".  This sends the receipt name to the ItemListViewController so it can load the items of that specific receipt
                let controller = segue.destination as! ViewControllerB
                controller.receiptName = AllReceipts[indexPath.row].receiptName!
            }
        }
    }
    
    //Sets number of sections of the table view
    func SecNum (in tableView: UITableView) -> Int {
        return 1
    }
    
    //Sets the number of rows for the table view
    //In this case, the table view will constantly expend, thereby using the array size of the Receipt entity
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(AllReceipts.count)
        return AllReceipts.count
    }
    
    
    //Uses identifier of table view cell (can be set in properties of the cell) to retrieve the data that will be displayed within each row of the table (in this case, its the receipt name)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let oneRecord = AllReceipts[indexPath.row]
        cell.textLabel!.text = oneRecord.receiptName!
        return cell
    }
    
    //Function that adds the swipe to delete function to the receipt view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Deletes the data and reloads the entire table view
            DeleteReceiptData(NameOfItem: AllReceipts[indexPath.row].receiptName!)
            viewDidLoad()
        }
    }
    
    
    //Function that fetches all data and inputs it into the table view
    //Must be changed to fetch all non-repeating data (this also implies the need to implement a restriction of not having the same receipt names for multiple receipts)
    func FetchData() {
        //Fetches the specific data
        guard let receiptObj = Receipt.FetchListOfReceipts()
            //If data is not found, returns no data found
            else {
                return
        }
        AllReceipts = receiptObj
        
    }
}
