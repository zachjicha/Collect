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
        
        //ViewController.title = "Items"
        
        
        //Sets up table view
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Receipt Items"
        
        self.FetchData(receiptName: receiptname)
        self.tableView.reloadData()
    }
    
    
    
    //Returns number of sections
    func SecNum (in tableView: UITableView) -> Int {
        return 1
    }
    
    //Returns number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllItems.count
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let oneRecord = AllItems[indexPath.row]
        cell.textLabel!.text = oneRecord.itemName!
        return cell
    }
    
    //Function that fetches all data and inputs it into the table view
    func FetchData(receiptName: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var receiptList = [ReceiptItems]()
        let request = NSFetchRequest<ReceiptItems>(entityName: "ReceiptItems")
        request.predicate = NSPredicate(format: "receiptName = %@", "receiptname")
        do {
            receiptList = try context.fetch(request)
            if receiptList.count > 0 {
                // You have found cover
            }
        }
        catch {
            print("Error = \(error.localizedDescription)")
        }
        
    }
}
