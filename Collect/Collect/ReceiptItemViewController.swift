//
//  ReceiptItemViewController.swift
//  Collect
//
//  Created by Brian Thyfault on 7/17/19.
//  Copyright © 2019 The Collective. All rights reserved.
//  YOOOOOOOOO

import UIKit

class ReceiptItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var peopleArray:[PeopleList] = []
    var receiptName:String = ""
    var AllItems:[ReceiptItems] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up table view
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Receipt Items"
        
        //Fetches the necessary data based on the receipt name passed from the previous storyboard/viewController
        self.FetchData(receiptName: receiptName)
        self.tableView.reloadData()
        print(AllItems)
    }
    
    
    
    //Sets number of sections of the table
    func SecNum (in tableView: UITableView) -> Int {
        return 1
    }
    
    //Sets the number of rows for the table view
    //In this case, the table view will constantly expend, thereby using the array size of the Receipt entity
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllItems.count
    }
    
    //Uses identifier of table view cell (can be set in properties of the cell) to retrieve the data that will be displayed within each row of the table (in this case, its the item names of within the receipt entity)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
        let receiptItem = AllItems[indexPath.row]
        cell.textLabel!.text = receiptItem.itemName!
        cell.detailTextLabel!.text = String(receiptItem
            .itemPrice)
        //TODO ADD COST HERE AS SUBTITLE
        return cell
    }
    
    //Fetches item data based on the receipt name selected
    //The receiptName is the data passed through the segue
    func FetchData(receiptName: String) {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNameSwitches" {
            
            let controller = segue.destination as! SelectNamesViewController
            controller.receiptName = receiptName
            
        }
    }
    

}
