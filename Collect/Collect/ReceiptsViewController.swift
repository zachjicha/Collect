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

        //ViewController.title = "Receipts"
        
        //Sets up table view
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Receipts"
        
        self.FetchData()
        self.tableView.reloadData()
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        //Access the array that you have used to fill the tableViewCell
        //print(AllReceipts[indexPath.row].receiptName!)
        receiptToOpen = AllReceipts[indexPath.row].receiptName!
        
    }
    //Override function for passing data from one ViewController to another
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ItemListViewController
        {
            let vc = segue.destination as? ItemListViewController
            vc?.receiptname = receiptToOpen
        }
    }*/
    
    
    //Returns number of sections
    func SecNum (in tableView: UITableView) -> Int {
        return 1
    }

    //Returns number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(AllReceipts.count)
        return AllReceipts.count
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let oneRecord = AllReceipts[indexPath.row]
        cell.textLabel!.text = oneRecord.receiptName!
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowReceiptItems", sender: indexPath) //Pass indexPath as sender instead of self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowReceiptItems" {
            
            let receiptPointer = segue.destination as! ItemListViewController
            let indexPath = sender as! IndexPath
            receiptPointer.receiptname = AllReceipts[indexPath.row].receiptName!
        }
    }
    
    
    
    
    //Function that fetches all data and inputs it into the table view
    func FetchData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            AllReceipts = try context.fetch(Receipt.fetchRequest())
        } catch{
            print(error)
        }
    }
    
    //Function that fetches specific data
    //Ideas: Use an array of numbers as keys for receipts
    func FetchSpecificData(key: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Receipt")
        let predicate = NSPredicate(format: "itemName = %@", argumentArray: ["1  Chardonay  4.45"])
        // Or for integer value
        // let predicate = NSPredicate(format: "amount > %d", argumentArray: [10])
        
        fetch.predicate = predicate
        
        do {
            
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "itemName") as! String)
            }
        } catch {
            print("Failed")
        }
    }
    

    //function that modifies/updates specific data (implement in main story board(?))
    
    
    
    
    
    
}
