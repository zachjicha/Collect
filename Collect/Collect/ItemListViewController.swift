//
//  ItemListViewController.swift
//  Collect
//
//  Created by Rizzian Tuazon on 7/11/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import CoreData

class ItemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var AllItems:[ReceiptItems] = []
    @IBOutlet weak var tableView: UITableView!
    
    var receiptname:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets up table view
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Receipt Items"
        
        //Fetches the necessary data based on the receipt name passed from the previous storyboard/viewController
        self.FetchData(receiptName: receiptname)
        self.tableView.reloadData()
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
        let oneRecord = AllItems[indexPath.row]
        cell.textLabel!.text = oneRecord.itemName!
        return cell
    }
    
    //Fetches item data based on the receipt name selected
    //The receipt name was the data passed through the segue
    func FetchData(receiptName: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //Creates fetch request
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
    }
}
